# **Docker_EE**
### **Task:**
1.	Create Vagrantfile which contains 3 nodes jenkinsmaster, swarmmaster and swarmslave1
2.	Create jenkins_install.sh for jenkinsmaster bootstrap and docker_install.sh for swarmmaster and swarmslave bootstrap.
3.	When bootstrap process has been done need to install UCP and DTR on the swarmmaster node.
4.	Add swarmmaster as jenkinsmaster slave via ssh.
5.	Initialize swarmmaster as a master node of the Docker Swarm cluster.
6.	Add swarmslave1 as a worker node of the Docker Swarm cluster.
7.	Deploy the application as Docker stack app in the Docker Swarm cluster.
8.	Create the Job which can build Java Spring App ( https://github.com/sqshq/PiggyMetrics ) 
9.	Create a GitHub repo with **Vagrantfile**, **docker_install.sh**, **jenkins_install.sh** and **README.md** which contains a progress of each step + commands output and screens+outputs of Jenkins job and UCP of deployed app
### **Notes:**
* Docker commands must run from sudo user without using sudo.
* Use Docker EE with one month trial license.
* This java project is being built by Maven builder, so you need to create a Maven builder in the Jenkins and use compile before docker stack deploy.
### **Project’s architecture overview:**
 ![Architecture](https://github.com/resident33/-Docker_EE/blob/Dev/src/Docker_EE%20project%E2%80%99s%20architecture%20overview.png)
Our infrastructure consist of 3 nodes:
* **vm-jenkinsmaster** - main place for Jenkins jobs runs.
* **vm-swarm_master** - is a jenkinsmaster's slave, where job will run and MASTER NODE of the Docker Swarm cluster. It includes installed Docker Enterprise Edition with Docker Swarm, Docker Compose, Universal Control Plane(UCP) and Docker Trusted Registry(DTR).
* **vm-swarm_slave** - is a WORKER NODE of the Docker Swarm cluster. It includes installed Docker Enterprise Edition with Docker Swarm and Docker Compose
# **Let's start**
### **Configure Vagrant**
 Initialize the directory as a Vagrant environment by creating the initial Vagrant file with the command:
```shell
vagrant init
```
  ![Vagrant_init_result](https://github.com/resident33/-Docker_EE/blob/Dev/src/1_Vagrant%20init.jpg)

 After that edit vagrantfile for our infrastructure.

 **Example Vagrant config:**
  ![Vagrant_config](https://github.com/resident33/-Docker_EE/blob/Dev/src/1.1_Vagrant%20file.jpg)
 
 Also, need to create jenkins_install.sh and docker_install.sh files, which is needed to install the necessary tools on our nodes.

 **Example jenkins_install.sh:**
  ![Jenkins_install](https://github.com/resident33/-Docker_EE/blob/Dev/src/1.2_Jenkins%20install%20file.jpg)

 **Example docker_install.sh:**
  ![Docker_install](https://github.com/resident33/-Docker_EE/blob/Dev/src/1.3_Docker%20install%20file.jpg)
 
 **Note:** To install Docker Enterprice Edition, you need to activate the a trial license [here](https://store.docker.com/my-content "Getting Started with Docker Enterprise")
 ![Docker_Enterprice](https://github.com/resident33/-Docker_EE/blob/Dev/src/1.4_Note%20Docker%20Enterpice.jpg)

 **Vagrant work result:**
 
 **Jenkins Master**
 ![Jenkins_master](https://github.com/resident33/-Docker_EE/blob/Dev/src/2_JenkinsMasterOutput.jpg)
 **Swarm Master**
 ![Swarm_master](https://github.com/resident33/-Docker_EE/blob/Dev/src/3.2_SwarmMasterOutput.jpg)
 **Swarm Slave**
 ![Swarm_slave](https://github.com/resident33/-Docker_EE/blob/Dev/src/4_SwarmSlave1Output.jpg)
 
 Next, go to the installation UCP and DTR on the swarmmaster node.
### **Universal Control Panel and Docker Trusted Registry install**

**Connect to swarmmaster**
```shell
vagrant ssh vm-swarmmaster
```
**Pull the latest version of UCP**
```shell
docker image pull docker/ucp:3.1.6
```
 ![Pull_image_UCP](https://github.com/resident33/-Docker_EE/blob/Dev/src/6.1_Install%20UCP%20pull%20Image.jpg)

**Install UCP**
```shell
docker container run --rm -it --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:3.1.6 install --host-address 10.10.102.221 --interactive
```
 ![Install_UCP_Result](https://github.com/resident33/-Docker_EE/blob/Dev/src/6.2_Install%20UCP%20finish%20.jpg)
 
 ![UCP_Web_UI](https://github.com/resident33/-Docker_EE/blob/Dev/src/6.3.0_UCP%20web%20UI%20.jpg)
 
 ![UCP_Dashboard](https://github.com/resident33/-Docker_EE/blob/Dev/src/6.3_Install%20UCP%20dashboard%20.jpg)
 
 **Install DTR**
 ```shell
docker run -it --rm docker/dtr install  --ucp-node vm-swarmmaster  --ucp-username resident  --ucp-url https://10.10.102.221:1443 --ucp-insecure-tls
```
 ![Install_DTR](https://github.com/resident33/-Docker_EE/blob/Dev/src/6.4_Install%20DTR%20.jpg)
 
 Also we can see DTR install status in UCP. Navigate to the Admin Settings page and in the left pane and click Docker Trusted Registry.
  ![Install_DTR_UCP](https://github.com/resident33/-Docker_EE/blob/Dev/src/6.4.2_Install%20DTR%20.jpg)
  
  ### **Connect Jenkins Slave to Jankins Master**
  
 The next step is to set up the slave nodes server. To do so, you need to install java on your server then create a Jenkins user.
  
  **Install Java**
  
 Start by installing the software packages then include the PPA repository for java. This will be accomplished using the apt-get command:
  
  ```shell
sudo apt-get install software-properties-common apt-transport-https -y
sudo add-apt-repository ppa:openjdk-r/ppa -y
```
 Use the following command to install java OpenJDK.

```shell
sudo apt-get install openjdk-8-jdk -y
```
  **Adding a New User for Jenkins**

```shell
sudo useradd -m -s /bin/bash Jenkins
sudo passwd Jenkins
```
  **Login as Jenkins user and generate SSH keys**

 ```shell
su Jenkins
mkdir ~/.ssh && cd ~/.ssh
ssh-keygen -t rsa -C "Key for Jenkins slaves"
cat id_rsa.pub > ~/.ssh/authorized_keys
```
 ![Generate_SHA_Key_swarmmaster](https://github.com/resident33/-Docker_EE/blob/Dev/src/8.1_Generate%20SHA_key%20for%20swarmmaster.jpg) 
 
 ```shell
cat id_rsa
```
 
 ![SHA_Key_swarmmaster](https://github.com/resident33/-Docker_EE/blob/Dev/src/8.2_Generate%20SHA_key%20for%20swarmmaster.jpg)

  **Add the private key to jenkins credential list**
  
 Go to jenkins dashboard –> credentials –> Global credentials –> add credentials , select and enter all the credentials as shown below and click ok.

 ![Jenkins_add_Global_credentials](https://github.com/resident33/-Docker_EE/blob/Dev/src/7.4%20Jenkins%20add%20credentials.jpg)
 
  **Setting up Jenkins slaves using username and private key**
  
 Check if the plugins are installed: SSH Agent Plugin and SSH Slaves Plugin on Jenkins, if not, install them.
 After head over to Jenkins dashboard –> Manage Jenkins –> Manage Nodes. Select New Node option. Give it a name, select the “permanent agent” option and click ok.

 ![Add_Jenkins_Slave](https://github.com/resident33/-Docker_EE/blob/Dev/src/9_Add%20jenkins%20slave.jpg)
 
 Save the changes and make sure the master server is connected to all the agent nodes before launching the agent services.
Once the master level has connected successfully to the agent nodes, you will see the screen below:

  ![Jenkins_Slave_Status](https://github.com/resident33/-Docker_EE/blob/Dev/src/9.1_Jenkins%20slave%20status.jpg)
  
 Now, the slave nodes have been added successfully to the Jenkins master server.

  ### **Create Swarm Cluster**
  
 Create cluster manager for machine vm with the following command:
 
 ```shell
docker swarm init --advertise-addr 10.10.102.221
```
 To retrieve the join command including the join token for worker nodes, run the following command on a manager node: 

```shell
docker swarm join-token worker
```
  ![Retrieve_Join_Swarm](https://github.com/resident33/-Docker_EE/blob/Dev/src/10_Add%20swarm%20node.jpg)
  
 Next we connect to vm-swarmslave1
 ```shell
vagrand ssh vm-swarmslawe1
```
 and use the command to add a worker node in docker swarm cluster:
 ```shell
docker swarm join --token SWMTKN-1-5wvxjn2uiw49mgalai7hxny2j58ybmmps2yz8n6woisfp0ljxh-elcsx33q46pduazd2p1z3tu3n 10.10.102.221:2377
```
  ![Add_Swarm_Node](https://github.com/resident33/-Docker_EE/blob/Dev/src/10.1_Add%20swarm%20node.jpg)

  ### **Jenkins Jobs's configuration**
  
 Go back to Jenkins, log in again if necessary and click create new jobs under Welcome to Jenkins!
 **Note:** If you don’t see this, click New Item at the top left.

 In the Enter an item name field, specify the name for your new Freestyle project.
Next specify the repository in the field Source Code Management (e.g. https://github.com/sqshq/piggymetrics.git)

  ![Configure_Jenkins_Job_Source_Code](https://github.com/resident33/-Docker_EE/blob/Dev/src/11_Configure%20Jenkins%20Job.jpg)
 
 Next, set Build options.
  
  ![Set_Bild_Options](https://github.com/resident33/-Docker_EE/blob/Dev/src/11.1_Configure%20Jenkins%20Job.jpg)
 
 After that you can save your job.
  
 ### **Jenkins Jobs's Console Output:**
 
 ```shell
Started by user Evgeniy
Running as SYSTEM
Building remotely on node1 (java ubuntu maven) in workspace /home/Jenkins/jenkins_slave/workspace/Piggy Metrics
using credential 8b93512c-16a2-40d1-b263-a470bf50210d
 > git rev-parse --is-inside-work-tree # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/sqshq/piggymetrics.git # timeout=10
Fetching upstream changes from https://github.com/sqshq/piggymetrics.git
 > git --version # timeout=10
using GIT_ASKPASS to set credentials Git Credentials
 > git fetch --tags --progress https://github.com/sqshq/piggymetrics.git +refs/heads/*:refs/remotes/origin/*
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
 > git rev-parse refs/remotes/origin/origin/master^{commit} # timeout=10
Checking out Revision 20237e62b4305dc888aa55b61e1e103fbd3856bf (refs/remotes/origin/master)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 20237e62b4305dc888aa55b61e1e103fbd3856bf
Commit message: "Merge pull request #48 from zuzhi/master"
 > git rev-list --no-walk 20237e62b4305dc888aa55b61e1e103fbd3856bf # timeout=10
[Piggy Metrics] $ /home/Jenkins/jenkins_slave/tools/hudson.tasks.Maven_MavenInstallation/maven/bin/mvn compile
[INFO] Scanning for projects...
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Build Order:
[INFO] 
[INFO] piggymetrics                                                       [pom]
[INFO] config                                                             [jar]
[INFO] monitoring                                                         [jar]
[INFO] registry                                                           [jar]
[INFO] gateway                                                            [jar]
[INFO] auth-service                                                       [jar]
[INFO] account-service                                                    [jar]
[INFO] statistics-service                                                 [jar]
[INFO] notification-service                                               [jar]
[INFO] turbine-stream-service                                             [jar]
[INFO] 
[INFO] -------------------< com.piggymetrics:piggymetrics >--------------------
[INFO] Building piggymetrics 1.0-SNAPSHOT                                [1/10]
[INFO] --------------------------------[ pom ]---------------------------------
[INFO] 
[INFO] ----------------------< com.piggymetrics:config >-----------------------
[INFO] Building config 1.0.0-SNAPSHOT                                    [2/10]
[INFO] --------------------------------[ jar ]---------------------------------

[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ config ---

[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 2 resources
[INFO] Copying 8 resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ config ---

[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] --------------------< com.piggymetrics:monitoring >---------------------
[INFO] Building monitoring 0.0.1-SNAPSHOT                                [3/10]
[INFO] --------------------------------[ jar ]---------------------------------

[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ monitoring ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] Copying 1 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ monitoring ---

[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] ---------------------< com.piggymetrics:registry >----------------------
[INFO] Building registry 0.0.1-SNAPSHOT                                  [4/10]
[INFO] --------------------------------[ jar ]---------------------------------

[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ registry ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] Copying 1 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ registry ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] ----------------------< com.piggymetrics:gateway >----------------------
[INFO] Building gateway 1.0-SNAPSHOT                                     [5/10]
[INFO] --------------------------------[ jar ]---------------------------------

[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ gateway ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] Copying 49 resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ gateway ---

[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] -------------------< com.piggymetrics:auth-service >--------------------
[INFO] Building auth-service 1.0-SNAPSHOT                                [6/10]
[INFO] --------------------------------[ jar ]---------------------------------

[INFO] 
[INFO] --- jacoco-maven-plugin:0.7.6.201602180812:prepare-agent (default) @ auth-service ---

[INFO] argLine set to "-javaagent:/home/Jenkins/.m2/repository/org/jacoco/org.jacoco.agent/0.7.6.201602180812/org.jacoco.agent-0.7.6.201602180812-runtime.jar=destfile=/home/Jenkins/jenkins_slave/workspace/Piggy Metrics/auth-service/target/jacoco.exec"
[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ auth-service ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] Copying 1 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ auth-service ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] ------------------< com.piggymetrics:account-service >------------------
[INFO] Building account-service 1.0-SNAPSHOT                             [7/10]
[INFO] --------------------------------[ jar ]---------------------------------

[INFO] 
[INFO] --- jacoco-maven-plugin:0.7.6.201602180812:prepare-agent (default) @ account-service ---
[INFO] argLine set to "-javaagent:/home/Jenkins/.m2/repository/org/jacoco/org.jacoco.agent/0.7.6.201602180812/org.jacoco.agent-0.7.6.201602180812-runtime.jar=destfile=/home/Jenkins/jenkins_slave/workspace/Piggy Metrics/account-service/target/jacoco.exec"
[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ account-service ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] Copying 1 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ account-service ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] ----------------< com.piggymetrics:statistics-service >-----------------
[INFO] Building statistics-service 1.0-SNAPSHOT                          [8/10]
[INFO] --------------------------------[ jar ]---------------------------------

[INFO] 
[INFO] --- jacoco-maven-plugin:0.7.6.201602180812:prepare-agent (default) @ statistics-service ---
[INFO] argLine set to "-javaagent:/home/Jenkins/.m2/repository/org/jacoco/org.jacoco.agent/0.7.6.201602180812/org.jacoco.agent-0.7.6.201602180812-runtime.jar=destfile=/home/Jenkins/jenkins_slave/workspace/Piggy Metrics/statistics-service/target/jacoco.exec"
[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ statistics-service ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] Copying 1 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ statistics-service ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] ---------------< com.piggymetrics:notification-service >----------------
[INFO] Building notification-service 1.0.0-SNAPSHOT                      [9/10]
[INFO] --------------------------------[ jar ]---------------------------------

[INFO] 
[INFO] --- jacoco-maven-plugin:0.7.6.201602180812:prepare-agent (default) @ notification-service ---
[INFO] argLine set to "-javaagent:/home/Jenkins/.m2/repository/org/jacoco/org.jacoco.agent/0.7.6.201602180812/org.jacoco.agent-0.7.6.201602180812-runtime.jar=destfile=/home/Jenkins/jenkins_slave/workspace/Piggy Metrics/notification-service/target/jacoco.exec"
[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ notification-service ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] Copying 1 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ notification-service ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] --------------< com.piggymetrics:turbine-stream-service >---------------
[INFO] Building turbine-stream-service 0.0.1-SNAPSHOT                   [10/10]
[INFO] --------------------------------[ jar ]---------------------------------

[INFO] 
[INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ turbine-stream-service ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] Copying 1 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ turbine-stream-service ---
[INFO] Nothing to compile - all classes are up to date
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary:
[INFO] 
[INFO] piggymetrics 1.0-SNAPSHOT .......................... SUCCESS [  0.030 s]
[INFO] config 1.0.0-SNAPSHOT .............................. SUCCESS [ 13.453 s]
[INFO] monitoring 0.0.1-SNAPSHOT .......................... SUCCESS [  3.727 s]
[INFO] registry 0.0.1-SNAPSHOT ............................ SUCCESS [  2.873 s]
[INFO] gateway ............................................ SUCCESS [  2.194 s]
[INFO] auth-service ....................................... SUCCESS [  8.781 s]
[INFO] account-service .................................... SUCCESS [  3.256 s]
[INFO] statistics-service ................................. SUCCESS [  0.985 s]
[INFO] notification-service 1.0.0-SNAPSHOT ................ SUCCESS [  0.816 s]
[INFO] turbine-stream-service 0.0.1-SNAPSHOT .............. SUCCESS [  0.950 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 45.362 s
[INFO] Finished at: 2019-05-09T15:38:51Z
[INFO] ------------------------------------------------------------------------

[Piggy Metrics] $ /bin/sh -xe /tmp/jenkins7315550704690390981.sh
+ sleep 5

+ whoami
Jenkins
+ hostname
vm-swarmmaster
+ sleep 5

+ docker stack deploy -c /vagrant/docker-compose.yml piggymetricks

Ignoring unsupported options: restart

Updating service piggymetricks_monitoring (id: dfpbdx8wjimo4ps5edlzfn5la)

Updating service piggymetricks_rabbitmq (id: ehlt98uygl8722sz6ogk0vtsy)

Updating service piggymetricks_auth-service (id: pwu7yhzv765ruhbisycwl8lvs)

Updating service piggymetricks_registry (id: l1r6aqh9c3y3ga66rvjpshf1u)

Updating service piggymetricks_notification-mongodb (id: raswp135xryqyf2pyf538cqpv)

Updating service piggymetricks_config (id: ir3iqpm56f52o47xfdgf3y10y)

Updating service piggymetricks_auth-mongodb (id: iihothamimap04t9q08okg2o6)

Updating service piggymetricks_account-service (id: tgw2q0iiens2psqtuwt64c246)

Updating service piggymetricks_gateway (id: ze9p2ppjob3y8dtx5c9pw2pg6)

Updating service piggymetricks_notification-service (id: w5m5u1ygzv7jv8tjbqeyn6xod)

Updating service piggymetricks_statistics-service (id: zexprbnbcik618mvozbnb1k82)

Updating service piggymetricks_statistics-mongodb (id: z02udphfokfnra4nd9020hzh0)

Updating service piggymetricks_account-mongodb (id: ihafxeregdxc1hvvoo2vibswx)

+ docker service ls
ID                  NAME                                 MODE                REPLICAS            IMAGE                                            PORTS
ihafxeregdxc        piggymetricks_account-mongodb        replicated          0/1                 sqshq/piggymetrics-mongodb:latest                
tgw2q0iiens2        piggymetricks_account-service        replicated          1/1                 sqshq/piggymetrics-account-service:latest        
iihothamimap        piggymetricks_auth-mongodb           replicated          0/1                 sqshq/piggymetrics-mongodb:latest                
pwu7yhzv765r        piggymetricks_auth-service           replicated          1/1                 sqshq/piggymetrics-auth-service:latest           
ir3iqpm56f52        piggymetricks_config                 replicated          0/1                 sqshq/piggymetrics-config:latest                 
ze9p2ppjob3y        piggymetricks_gateway                replicated          1/1                 sqshq/piggymetrics-gateway:latest                *:80->4000/tcp
dfpbdx8wjimo        piggymetricks_monitoring             replicated          0/1                 sqshq/piggymetrics-monitoring:latest             *:8989->8989/tcp, *:9000->8080/tcp
raswp135xryq        piggymetricks_notification-mongodb   replicated          0/1                 sqshq/piggymetrics-mongodb:latest                
w5m5u1ygzv7j        piggymetricks_notification-service   replicated          1/1                 sqshq/piggymetrics-notification-service:latest   
ehlt98uygl87        piggymetricks_rabbitmq               replicated          1/1                 rabbitmq:3-management                            *:15672->15672/tcp
l1r6aqh9c3y3        piggymetricks_registry               replicated          0/1                 sqshq/piggymetrics-registry:latest               *:8761->8761/tcp
z02udphfokfn        piggymetricks_statistics-mongodb     replicated          0/1                 sqshq/piggymetrics-mongodb:latest                
zexprbnbcik6        piggymetricks_statistics-service     replicated          0/1                 sqshq/piggymetrics-statistics-service:latest     
n88549arq6xf        ucp-agent                            global              2/2                 docker/ucp-agent:3.1.6                           
6aumm8ii1xp8        ucp-agent-win                        global              0/0                 docker/ucp-agent-win:3.1.6                       
mbndre6wip5o        ucp-auth-api                         global              1/1                 docker/ucp-auth:3.1.6                            
w5vcp90sgvit        ucp-auth-worker                      global              1/1                 docker/ucp-auth:3.1.6                            

Finished: SUCCESS
```
 
 ### **Docker EE Dashboard -> Services:**
 
  ![Bild_Result_Dashboard_Services](https://github.com/resident33/-Docker_EE/blob/Dev/src/12_Bild%20result%20services.jpg)
 
 
  
 
  
  
 






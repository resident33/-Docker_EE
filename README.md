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
  
  ### **Connect Jankins Slave to Jankins Master**

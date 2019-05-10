# **Docker_EE**
### **TASK**
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

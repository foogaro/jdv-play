# Terminology

First things first.

It's important that we all speak the same language, or at least we mean the same thing.

| Terms     | Descritpion                    |
| ----------|--------------------------------|
| RHEL      | It stands for **R**ed **H**at **E**nterprise **L**inux, it is a Linux distribution developed and mantained by Red Hat. |
| DBMS      | It stands for **D**ata**b**ase **M**anagement **S**ystem, it is a computer program designed to manage a database, a large set of structured data, and run operations on the data requested by numerous users. |
| RDBMS     | It stands for **R**elational **D**ata**b**ase **M**anagement **S**ystem, it is a database management system (DBMS) that is based on the relational model. |
| API       | It stands for **A**pplication **P**rogramming **I**nterface, it is a set of subroutine definitions, protocols, and tools for building application software. |
| JDBC      | It stands for **J**ava **D**ata**b**ase **C**onnectivity, it is an application programming interface (API) for the Java programming language, which defines how a client can access a database. |
| ODBC      | It stands for **O**pen **D**ata**b**ase **C**onnectivity, it is a standard application programming interface (API) for accessing database management systems (DBMS) |
| TCP       | It stands for **T**ransmission** **C**ontrol **P**rotocol, it is one of the main protocols of the Internet protocol suite. |
| HTTP      | It stands for **H**yper**t**ext **T**ransfer **P**rotocol, it is an application protocol for distributed, collaborative, and hypermedia information systems. |
| REST      | It stands for **Re**presentational **S**tate **T**ransfer (also known as RESTful Web services), it is one way of providing interoperability between computer systems on the Internet. |
| SOAP      | It stands for **S**imple **O**bject **A**ccess **P**rotocol, it is a protocol specification for exchanging structured information in the implementation of web services in computer networks. |
| SQL       | It stands for **S**tructure **Q**uery **L**anguage, it is a domain-specific language used in programming and designed for managing data held in a relational database management system (RDBMS). |
| DDL       | It stands for **D**ata **D**efinition **L**anguage, it is used to define the database structure or schema. |
| DML       | It stands for **D**ata **M**anipulation **L**anguage, it is used for managing data within schema objects. |
| NOSQL     | It stands for **N**ot **O**nly **SQL**, it is a kind of a database, which provides a mechanism for storage and retrieval of data which is modeled in means other than the tabular relations used in relational databases. |
| JDV       | It stands for JBoss Data Virtualization. [See more](#Overview)|
| DV        | It stands for Data Virtualization, it is used as synonymous of JDV. |
| Image     | It's meant to be the software stack, that will compose a runtime environment. In our scenario, it's meant to be a Docker image. |
| Container | It's meant to be a Linux container, based on a spefici image. In our scenario a Docker container. |
| Host      | It's meant to be the server running this repo, thus hosting Docker's image repository. |
| Guest     | It's deprecated. In case of use, refer to it as container, actually a *named* container. |
| HA        | It stands for **H**igh **A**vailability, it is a characteristic of a system, which aims to ensure an agreed level of operational performance, usually uptime, for a higher than normal period. |
| IHIH      | It stands for **I** **H**ope **I**t **H**elps, ça va sans dire. |

# <a name="Overview"></a>Overview
JBoss Data Virtualization is a __data abstraction middleware layer__.
Generally speaking it belongs to _Big Data_ in terms of data integration.
With __JDV__ you can model, compose and integrate your data domain objects by importing database of any kind (_RDBMS, NoSQL, spread sheets, hadoop, SAP, text files, etc..._), and have them exposed in the way is more comfortable to you (meant as client applicaiton) to read, either in terms of _structure_, either in terms of access _protocols_.

JDV supports:
* JDBC;
* ODBC;
* REST;
* SOAP;
* OData v4 (also partially OData v2).

In this repository you will find a MySQL's Docker files along with its DDL and DML files (mysql folder), a JDV project (jdv-play folder) based on JBoss Developer Studio with Teeid's plugins, JDV's Docker files (jdv folder), and HAProxy's Docker files (haproxy folder).


## Prerequisites

You need a "couple" of things:
* internet connection;
* docker installed;
* RHEL subscription to use;
* JDV installer;
* enough disk space (you will not believe how docker enlarge _itself_);
* git clone this repo.

## Docker networking (just a bit)

The base of linux containers is isoltation. When running docker containers (mind the "s") you probably want some of those containers interact with others, and some of them _not_ to interact with others.
Docker helps you achieve this by creating subnet.
Along with all _jdv-play_ we will use a network called __jdv__.

Just follow those easy steps:

```bash
docker network create jdv
8af8d25ea76210b473ab535750a56560f41ed5f249f858b3cb8b89fb75546837
docker network inspect jdv
[
    {
        "Name": "jdv",
        "Id": "8af8d25ea76210b473ab535750a56560f41ed5f249f858b3cb8b89fb75546837",
        "Created": "2017-05-19T12:30:35.841439238Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
```

### Build the RHEL base image

All Docker images belong to this project are based on RHEL, so we first need to build tha base image.
Edit the file named rhel.dockerfile and use your own credential to register your the Red Hat Network.
Here is an example:

```bash
FROM registry.access.redhat.com/rhel:latest

MAINTAINER Foogaro <l.fugaro@gmail.com>

RUN subscription-manager register --username YOURUSERNAME --password DONOTUSEPASSWORDDOTONE
RUN subscription-manager attach --auto
RUN yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel 
RUN yum install -y which net-tools mlocate
RUN yum -y update && yum clean all

```


## MySQL

First we will create a data container to store our database. Doing so, any update to MySQL will be kept locally on the host machine (that is your laptop running all this).
Then, we will run a mysql container linking the data container. Once done, we will run the script to create and populate our database.
I took the database from XXX's repo.

### Build the data container
```bash
docker build -f mysql_data.dockerfile -t foogaro/mysql_data .
```
The above command is wrapped into the __mysql_data.build__ file.

### Create the data container
```bash
docker create --name mysql_data foogaro/mysql_data
```
The above command is wrapped into the __mysql_data.create__ file.

### Run MySQL linking the data container
```bash
docker run -it --rm=true --name="mysql" --net="jdv" --volumes-from mysql_data -v /jdv-play/mysql/var/lib/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 mysql
```
The above command is wrapped into the __mysql_data.create__ file.

### Create and populate database
It's gonna be tricky (and I'm pretty sure it's because of me)

```bash
cp employees.ddl var/lib/mysql/
unzip mysql-load-departments.zip -d var/lib/mysql/
unzip mysql-load-dept-emp.zip -d var/lib/mysql/
unzip mysql-load-dept-manager.zip -d var/lib/mysql/
unzip mysql-load-employees.zip -d var/lib/mysql/
unzip mysql-load-salaries.zip -d var/lib/mysql/
unzip mysql-load-titles.zip -d var/lib/mysql/
```
The above commands are wrapped into the __mysql_data.load__ file.

It will just place DML files into the shared volume, so you can have the loading phase within the mysql container as follows:

```bash
docker exec -ti mysql /bin/bash
```

Now inside the mysql container execute the following:

```bash
mysql -u root -proot < /var/lib/mysql/employees.ddl
mysql -u root -proot employees < /var/lib/mysql/mysql-load-departments.dml
mysql -u root -proot employees < /var/lib/mysql/mysql-load-dept-emp.dml
mysql -u root -proot employees < /var/lib/mysql/mysql-load-dept-manager.dml
mysql -u root -proot employees < /var/lib/mysql/mysql-load-employees.dml
mysql -u root -proot employees < /var/lib/mysql/mysql-load-salaries1.dml
mysql -u root -proot employees < /var/lib/mysql/mysql-load-salaries2.dml
mysql -u root -proot employees < /var/lib/mysql/mysql-load-salaries3.dml
mysql -u root -proot employees < /var/lib/mysql/mysql-load-titles.dml
```

Unfortunately the following docker command didn't work:
```bash
docker exec -ti mysql mysql -u root -proot < /var/lib/mysql/employees.ddl
```
or

```bash
docker exec -ti mysql "mysql -u root -proot < /var/lib/mysql/employees.ddl"
```

Not even the mysql-command wrapped into a executable file!

I spent an afternoon, and it didn't work!

Please send me a PR with the fix!

### Client SQL 
Now, if the steps above were successfully, you can have a look at the database with your favorite SQL client, and you should have the following schema:

![alt text][ref-employees-db]

And the count for each table should be as follows:

| Schema        | Tables        | Count     |
| --------------|---------------| ---------:|
| employees     | departments   |         9 |
| employees     | dept_emp      |   331.603 |
| employees     | dept_manager  |        24 |
| employees     | employees     |   300.024 |
| employees     | salaries      | 2.844.047 |
| employees     | titles        |   443.308 |


## JDV
Make sure you have placed into the software folder, the following files:
* jboss-dv-6.3.0-installer.jar
* jboss-dv-6.3.5-patch.jar
* mysql-connector-java-5.1.40-bin.jar

### Build the image
```bash
./jdv.build
```

### Run the container "jdv1"
```bash
./jdv1.run
```

### Configure the container "jdv1"
```bash
./jdv1.configure
```

### Run the container "jdv2"
```bash
./jdv2.run
```

### Configure the container "jdv2"
```bash
./jdv2.configure
```


## HAProxy
HAProxy is free, open source software that provides a high availability load balancer and proxy server for TCP and HTTP-based applications that spreads requests across multiple servers.

### Build the image
```bash
./haproxy.build
```

### Run the container "haproxy"
```bash
./haproxy.run
```

### Status and statistics
You can now access HAProxy's statistics page at the following URL (credentials are specified into the haproxy.cfg file):

[http://127.0.0.1](http://127.0.0.1)

And you should see the following page: 

![alt text][ref-haproxy-stats]

# Conclusion

Everything is up and running.

Check it via Docker as follows:
```bash
docker network inspect jdv
[
    {
        "Name": "jdv",
        "Id": "8af8d25ea76210b473ab535750a56560f41ed5f249f858b3cb8b89fb75546837",
        "Created": "2017-05-19T12:30:35.841439238Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Containers": {
            "28cf4be3ddbdd147732db95c2d0a1b6d53bbe0decc89fd07533292f95a1be456": {
                "Name": "jdv1",
                "EndpointID": "029f0aa2bd384b2564fabf53426395dd10a1ff5f09743ca4bf6a8e1d9d8fde61",
                "MacAddress": "02:42:ac:12:00:03",
                "IPv4Address": "172.18.0.3/16",
                "IPv6Address": ""
            },
            "525216a59756266270b9f049fa3ebb7912251012af9fe04a7146f06bd64cc669": {
                "Name": "mysql",
                "EndpointID": "44a7df9ef223915314b01bb848bd3d84bb17a3b281f0f5dac5e55c1aa77fd2cf",
                "MacAddress": "02:42:ac:12:00:02",
                "IPv4Address": "172.18.0.2/16",
                "IPv6Address": ""
            },
            "84eb2e037f633c502e2260124413fa7516d8d28ce1403a367f0fc38135ef970d": {
                "Name": "haproxy",
                "EndpointID": "e1c5a9818bddb9c6956cac05736f8e1eb63a5fc29af039eee929417382a09e7b",
                "MacAddress": "02:42:ac:12:00:05",
                "IPv4Address": "172.18.0.5/16",
                "IPv6Address": ""
            },
            "c8626c54f8f9f872ea7bd963d9babb6b83f68abf59201b6236b5e6649a06423a": {
                "Name": "jdv2",
                "EndpointID": "7734edbee4c58b89795ad593ab7bec013ad63cc1bba42497b2a498e409657b4d",
                "MacAddress": "02:42:ac:12:00:04",
                "IPv4Address": "172.18.0.4/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```

You can now access your Virtual Database from just one entrypoint, that is HAProxy, by using the protocol that best fits your needs.
Connect to the "EMP" Virtual database using JDBC, ODBC, or the protocol you prefer, by pointing to the HAProxy's IP and port (JDBC=31000, ODBC=35432, OData=8080).

Now play around... and yes you are allowed to stop one server, start it back and stop the other one, and so on and so on.

IHIH,

Ciao,

Luigi



[ref-employees-db]: https://github.com/foogaro/jdv-play/blob/master/db.png "Employees database reference"
[ref-haproxy-stats]: https://github.com/foogaro/jdv-play/blob/master/haproxy.png "HAProxy statistics reference"

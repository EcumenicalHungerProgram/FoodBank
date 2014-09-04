FoodBank
========

A Salesforce application suitable for running a food bank.

## Development Environment Setup

1. Install [Apache Ant](http://ant.apache.org/).
2. Clone this repository into a directory of your choosing.
3. Download the [Force.com Migration Tool](https://na3.salesforce.com/dwnld/SfdcAnt/salesforce_ant_31.0.zip).
4. Install the [Force.com IDE](http://wiki.developerforce.com/page/Force.com_IDE).

### Create a new Sandbox on Salesforce

As a developer you will likely be involved with multiple sandboxes.
Choose a name like "staging", "dev", "production", or whatever name you prefer

Salesforce: [Creating or Refreshing a Sandbox](https://help.salesforce.com/HTViewHelpDoc?id=data_sandbox_create.htm&language=en_US)

**Note**: You will be deploying this application into one (or more) of your sandboxes.

## Getting the Source

    git clone https://github.com/EcumenicalHungerProgram/FoodBank.git <sandbox dir>

##  Deploy to your Sandbox

Don't forget to generate a [security token](https://help.salesforce.com/apex/HTViewHelpDoc?id=user_security_token.htm).

### Configure your Environment for your Sandbox

In your <sandbox dir> create your build.properties file:

    sf.username = <your username>
    sf.password = <your password (plus security token)>
    sf.serverurl = https://test.salesforce.com
    sf.maxPoll = 20

### Deploy to your Sandbox

    ant deploy

You are now ready to start entering your data.

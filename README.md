FoodBank
========

A Salesforce application suitable for running a food bank.

## Development Environment Setup

As a developer you will likely be involved with multiple sandboxes.
Choose a name like "staging", "dev", "production", or whatever name you prefer

1. Install [Apache Ant](http://ant.apache.org/).
2. Install the [Force.com IDE](http://wiki.developerforce.com/page/Force.com_IDE).
3. Download the [Force.com Migration Tool](https://na3.salesforce.com/dwnld/SfdcAnt/salesforce_ant_31.0.zip).

### Initial Checkout

Don't forget to generate a [security token](https://help.salesforce.com/apex/HTViewHelpDoc?id=user_security_token.htm).

Salesforce: [Creating or Refreshing a Sandbox](https://help.salesforce.com/HTViewHelpDoc?id=data_sandbox_create.htm&language=en_US)

**Note**: You will be deploying this application into one (or more) of your sandboxes.

1. First clone this repository int a directory name of your choosing. In this example we'll
use "FoodBank-test".

<pre>
    git clone https://github.com/EcumenicalHungerProgram/FoodBank.git /path/to/java/workspace/FoodBank-test
</pre>

2. Create a new Force.com project in Eclipse.
  1. Name it "FoodBank-test".
  2. Enter your Salesforce credentials.
  3. Choose to sync nothing.

3. Delete the "src" folder (from with Eclipse).

4. setup your build.properties file:
   
<pre>
    # build.properties
    #
    
    # Specify the login credentials for the desired Salesforce organization
    sf.username = <your username>
    sf.password = <password><security token>
    #sf.pkgName = <Insert comma separated package names to be retrieved>
    #sf.zipFile = <Insert path of the zipfile to be retrieved>
    #sf.metadataType = <Insert metadata type name for which listMetadata or bulkRetrieve operations are to be performed>
    
    # Use 'https://login.salesforce.com' for production or developer edition (the default if not specified).
    # Use 'https://test.salesforce.com for sandbox.
    sf.serverurl = https://test.salesforce.com
    
    sf.maxPoll = 20
    # If your network requires an HTTP proxy, see http://ant.apache.org/manual/proxy.html for configuration.
    #
</pre>

### Deploy to your Sandbox

    ant deploy

You are now ready to start entering your data.

If you've made a change in Salesforce and you want to bring it down then:

    ant retrieve

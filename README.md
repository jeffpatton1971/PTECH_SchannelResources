# PTECH Schannel Resources

A collection of PowerShell DSC Resources for working with the various SCHANNEL registry entries. There are a total of 5 resources that will allow you to setup your system. These resources were designed with servers in mind, but where there are client settings those should be available for use.

As these Resources are adding entries to the Registry, in order to make sure a given entryis disabled, you must set Ensure to Present.

## Disable Schannel Protocol

This Resource will allow you to disable various SCHANNEL protocols. This is very useful for closing your system to several known exploits, the most well-known of which is POODLE. The Resource has implemented 4 properties:

* Protocol
* Target
* Reboot
* Ensure

## Enable Schannel Cipher

This Resource will allow you to enable various SCHANNEL ciphers, based on your given requirements. The Resource has implemented 3 properties:

* Cipher
* Reboot
* Ensure
 
## Enable Schannel Hash

This Resource will allow you to enable MD5 or SHA hashes. The Resource has implemented 3 properties:

* Hash
* Reboot
* Ensure

## Enable Schannel Key Exchange Algorithms

This Resource will allow you to enable Diffie-Hellman or PKCS Algorithms. The Resource has implemented 3 properties:

* KeyExchangeAlgorithm
* Reboot
* Ensure

## Set Schannel Cipher Order

This Resource will allow you to set the specific Cipher Order for your system. This order is a comma seperated list passed in as a single string. The Resource has implemented 3 properties:

* CipherOrder
* Reboot
* Ensure

## Sample Configuration

There is a sample configuration that shows how to use these Resources on your system.

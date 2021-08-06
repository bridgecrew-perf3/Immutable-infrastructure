Immutable Infrastructure in  AWS nginx instances in ha setup created with packer ansible and terraform

Immutable infrastructure is an approach to managing services and software deployments on IT resources wherein components are replaced rather than changed. An application or services is effectively redeployed each time any change occurs.

it helps with preventing configuration drifts - which create diffences between servers since ypu can ssh into many server and patch update for it to work leading you to having 10 to 100s of server not being in a known state.
and helps prevent snowflake servers which is any server that requires special configuration beyond that is covered by automated deployment scripts.

so essentially the goal is to replace instances on each release with a replacement image containing the application. This way we can swap out the whole instance quickly wihout furthur installation steps after provisioning.

this is sometimes called a golden image or a common image and for that we will use packer to create and bake an aws AMI and ansible to configure and install dependencies which we will be baking an NGINX webserver onto the image.

Terraform will the next choice for infrastucture as code and is a good choice since it can create change and deploy and destroy infrastructure remotely and keep track of the current state of the system.

so first we'll use a packer file with information about the AMI we want to create which includes
- a base ami
- type of instance storage t2.micro
- the name of the desired new AMI
- and a provisoner which will be used in conjucion with packer which would be Ansible.

once packer has create the instnace. ansible is used to apply additional configuration by using
-playbooks that install and enable nginx serving on port 80


then we will use terrafrom to deploy the infrastructure which will consist of
- an application load balancer
- two subnets that contain an ec2 instanc in each subnet
- an auto scalling group that has a min of 2 and max of 4
- creates a vpc, IG, route table, RTA, subnets, asg, sg, loadbalancers.
- an s3 for logging
- and if desired a backend s3 resource to store the terraform state if this would be a project
that a team will be wokring on.

this was all spun on as a home lab and the future goal of it is to
-have jenkins autoomate the entire proces within a pipeline so that when any changes happen to the ansible code it will automatically pick up any changes and roll out the new golden image to production.

and after that I'd like to create the same type of infrastructure but this time using EKS with a databse involved.
because databases because i was curious on what will happend if a persistant DB was involved.


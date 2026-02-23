# cloud-engineer-assessment

1. Getting started

Export your AWS IAM AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY as well as an AWS_REGION by running the following commands depending on your OS.

Linux: 

~~~
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_REGION="us-east-1"
~~~

Windows (CMD):

~~~
set AWS_ACCESS_KEY_ID="anaccesskey"
set AWS_SECRET_ACCESS_KEY="asecretkey"
set AWS_REGION="us-east-1"
~~~

Windows (PowerShell):
~~~
$env:AWS_ACCESS_KEY_ID="anaccesskey"
$env:AWS_SECRET_ACCESS_KEY="asecretkey"
$env:AWS_REGION="us-east-1"
~~~

Then go to a project directory and run:

~~~
terraform plan
~~~

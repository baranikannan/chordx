Chordx Assignment
-----------------
Requirement

1. Bandwidth/Latency Simulator
To build a script to change Latency between different thresholds. For example:
none (no latency change)
low 100 ms)
medium (500 ms)
high 1000 ms)
As a User, I want to be able to run a shell script and simulate latency or
bandwidth limitation on the host machine.

2. Monitoring Docker Compose
To build a docker compose file which will include Grafana image which will
show real-time Latency.


Implementations Details
-----------------------

As per the above requirement latency.sh file was created.

Using Docker Compose the monitoring stack was created. 

#docker-compose up 
 
Will bring the containers to running. Influx DB folder will be created in the current path of script execution.

Since the container runs in host network the port 3000 should not be used byu any other processes.

Grafana URL would be http://<host IP>:3000
 
Initial username/password is admin/admin.

Password must be changed during the first login.
Multiple input metrics were added in the telegraf.conf to grab the required metrics.
Host file systems were mounted in telegraf container to grab the required metrics. 




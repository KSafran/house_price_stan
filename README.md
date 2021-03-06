# house_price_stan
Predict House Prices using Stan

# Running on AWS
ssh into your EC2 instance
```
ssh -i <keyfile.pem> ec2-user@<ip address>
```
Clone this repo
```
sudo yum install git
git clone https://github.com/KSafran/house_price_stan.git
```
##Download the kaggle dataset
To download this you'll need to use the [kaggle API.](https://github.com/Kaggle/kaggle-api)
```
sudo yum install python3
sudo pip3 install kaggle
```
You'll need to copy your keys onto the EC2 instance for this to work. Obiously run this from your local computer.
```
scp -i <keyfile.pem> ~/.kaggle/kaggle.json ec2-user@<ip address>:~
```
Back on the EC2 instance
```
mkdir ~/.kaggle
mv kaggle.json ~/.kaggle/
cd house_price_stan/
mkdir data
cd data
kaggle competitions download -c house-prices-advanced-regression-techniques
cd ..
```
Now start up the docker container
```
sudo yum install -y docker
sudo service docker start
sudo usermod -aG docker ec2-user
```
Re-ssh into the machine for the ec2-user permissions to take
```
docker build -t houses .
docker run -d -e PASSWORD=pass -p 80:80 houses
docker exec -it <containerId> /bin/bash
nohup Rscript model.R
exit
docker cp <containerId>:/app/data/model_fit.rds ~
```
Go back to your machine and scp down the model file
```
scp -i <keyfile.pem> ec2-user@<ip address>:~/model_fit.rds .
```




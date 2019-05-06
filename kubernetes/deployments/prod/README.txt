1. manually created a EBS volume using aws ec2 command

 aws ec2 create-volume --availability-zone=us-west-2a --size=50 --volume=gp2

2. Created a storage class 

kubectl create -f ebs-storageclass.yaml

[support@10.0.165.21 prod]$ kubectl get storageclass
NAME            PROVISIONER                    AGE
default         kubernetes.io/aws-ebs          94d
gp2 (default)   kubernetes.io/aws-ebs          94d
local-storage   kubernetes.io/no-provisioner   1d
[support@10.0.165.21 prod]$ kubectl create -f ebs-storageclass.yaml
storageclass.storage.k8s.io/aws-ebs-class created
[support@10.0.165.21 prod]$ kubectl get storageclass
NAME            PROVISIONER                    AGE
aws-ebs-class   kubernetes.io/aws-ebs          3s        <<<<------------ newly created
default         kubernetes.io/aws-ebs          94d
gp2 (default)   kubernetes.io/aws-ebs          94d
local-storage   kubernetes.io/no-provisioner   1d



3. Create Persistent volume in AWS using the volumeID from the one created above

[support@10.0.165.21 prod]$ kubectl create -f ebs-pv.yaml
persistentvolume/aws-ebs-vol1 created
[support@10.0.165.21 prod]$ ls
ebs-pv.yaml  ebs-storageclass.yaml  README.txt
[support@10.0.165.21 prod]$ kubectl get pv
NAME           CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS    REASON   AGE
aws-ebs-vol1   50Gi       RWO            Delete           Available           aws-ebs-class            46s

4. 



##Generating a new SSH key
```
# ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
ssh-keygen -t rsa -b 4096 -f ~/.ssh/MyKeyPair.pem -q -P ''
chmod 400 ~/.ssh/MyKeyPair.pem
ssh-keygen -y -f ~/.ssh/MyKeyPair.pem > ~/.ssh/MyKeyPair.pub
```

## Usage
```
cd app-test
./run.sh
```

## Cleanup

```
cd app-test
terraform destroy
```

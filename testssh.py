import paramiko, base64

ssh = paramiko.SSHClient()
ssh.connect('192.168.25.6', username=sage, password=sage)
ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command('sage_ctrl sage_ctrl JCD:14C1:52 0')
print ssh_stdout
ssh.close()
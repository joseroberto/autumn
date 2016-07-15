import paramiko, base64

sage = '192.168.25.6'
ssh = paramiko.SSHClient()
ssh.load_system_host_keys()
ssh.connect(sage, username='sage', password='sage')
ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command('sage_ctrl JCD:14C1:52 0')
#ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command('ls')
for line in ssh_stdout:
    print '... ' + line.strip('\n')
ssh.close()
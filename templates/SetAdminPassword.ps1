$admin = [adsi]("WinNT://./administrator, user")
$admin.PSBase.Invoke("SetPassword", "{{ admin_password }}")

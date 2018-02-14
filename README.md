win_base
=========

Install base window system for us.

This will get common widow packages

- filebeat
- winlogbeat
- google-chrome

It also deploy a startup powershell commands and change the password of user
Administrator from initial_password to the the one defined in inventory
(ansible_password)

if it is an ec2 instance:
    - ec2 launch
    - TBA
    

Requirements
------------

This requires the latest win_scheduled_task module - see
https://github.com/ansible/ansible/pull/28995

Role Variables
--------------

Please see default/main.yml for now until I document here in details.

- `win_base_scheduled_tasks`: a list of dict to define a scheduled tasks we are
going to deploy in the target hosts.

- `winrm_certificate_thumbprint` - Optional - No default - The Thumbprint of the (already imported) certificate to be used for WINRM.
 Usually at this stage the remote box has already run the PS script
 ConfigureRemotingForAnsible.ps1 thus it would already have a certificate (self
 signed) for winrm. Using this option to set if you need other cert for it.

- `win_base_certificate_dir` - Optional - Default to `<ansible_install_dir>\ssl`
 The directory in the remote host to store the certificate for import/export
 operations.

- `win_base_certificates` - Optional - Default empty - List of dict to import the certificate in.
 If provided the `src` key are compulsory to point to the local certificate
 file so it can be copied to the remote. All other key name is matched with
 parameter name of the ansible module win_certificate_store.
 See http://docs.ansible.com/ansible/devel/module_docs/win_certificate_store_module.html
 Except parameter `path` which will be auto created from `<win_base_certificate_dir>\<current-cert-filename>`
 
Dependencies
------------


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).

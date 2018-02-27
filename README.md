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

- `win_base_dirs` - Optional - Default is empty 
   List of dict describe directories to be created. The key name is the same as
   parameter name for the ansible module win_file and win_acl. Proper ACL will
   be set if these keys are provided. 

   See [win_file](http://docs.ansible.com/ansible/latest/win_file_module.html)

   Also [win_acl](http://docs.ansible.com/ansible/latest/win_acl_module.html)

   Example:
   ```
   win_base_dirs:
     path: 'c:\ansible_install'
     type: deny
     rights: ExecuteFile,Write
     user: Fed-Phil
   ```

- `winrm_certificate_thumbprint` - Optional - No default 
   The Thumbprint of the (already imported) certificate to be used for WINRM.
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
 
- `ec2_persistent_volumes` - Optional default empty list. 
   List of Volumes to be formated as second or third disks etc..

   This variables are also be used in the role ec2_persistent_volume to create
   (if not existed yet) the volume, and role ec2_install to attach at launch
   time.

   The final list of disks to be managed is 
   `ec2_volumes[1:] + ec2_persistent_volumes`. 
   `ec2_volumes` are not persistent however. 
   
   Complete Example:
   ```
   launch_zone: a
    ec2_subnet_name: "xvt-{{ vpc_name }}-subnet-{{ role_type }}-{{ launch_zone }}"
    ec2_volumes:
	  - device_name: /dev/sda1
	    volume_type: gp2
	    volume_size: 50
	    delete_on_termination: true
	# Disk D and L are persistent storage.
	ec2_persistent_volumes_extra_tags_disk1:
	  Name: "{{ env }}-{{ role_type }}-disk1"
	  Device: "/dev/xvdf"
	
	ec2_persistent_volumes_extra_tags_disk2:
	  Name: "{{ env }}-{{ role_type }}-disk2"
	  Device: "/dev/xvdg"
	
	# That is for the ec2_persistent_volume to create the volume
	ec2_persistent_volumes:
	  - name: "{{ ec2_persistent_volumes_extra_tags_disk1.Name }}"
	    number: 1
	    drive_letter: D
	    label: DATA
	    volume_type: gp2
	    volume_size: 100
	    delete_on_termination: false
	    encrypted: true
	    tags: "{{ ec2_instance_base_tags|combine(ec2_persistent_volumes_extra_tags_disk1) }}"
	    zone: "{{ region }}{{ launch_zone }}"
	  - name: "{{ ec2_persistent_volumes_extra_tags_disk2.Name }}"
	    number: 2
	    drive_letter: L
	    label: LOG
	    volume_type: gp2
	    volume_size: 100
	    delete_on_termination: false
	    encrypted: true
	    tags: "{{ ec2_instance_base_tags|combine(ec2_persistent_volumes_extra_tags_disk2) }}"
	    zone: "{{ region }}{{ launch_zone }}"
	
	# This is for the ec2_instance to attach the persistent vol to the instance.
	ec2_instance_persistent_vol_tags:
	  Name: "{{ env }}-{{ role_type }}"
	  Application: "{{ role_type }}"
	  Environment: "{{ env }}"

   ```


Dependencies
------------


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables
passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).

# encoding: utf-8


# This module encapsulates ability to manage Proxmox server
module LXC
  # Object to manage Proxmox server
    # Get CT list
    #
    # :call-seq:
    #   lxc_get -> Hash
    #
    # Return a Hash of all lxc container
    #
    # Example:
    #
    #   lxc_get
    #
    # Example return:
    #   {
    #     '101' => {
    #           'maxswap' => 536870912,
    #           'disk' => 405168128,
    #           'ip' => '192.168.1.5',
    #           'status' => 'running',
    #           'netout' => 272,
    #           'maxdisk' => 4294967296,
    #           'maxmem' => 536870912,
    #           'uptime' => 3068073,
    #           'swap' => 0,
    #           'vmid' => '101',
    #           'nproc' => '10',
    #           'diskread' => 0,
    #           'cpu' => 0.00031670581100007,
    #           'netin' => 0,
    #           'name' => 'test2.domain.com',
    #           'failcnt' => 0,
    #           'diskwrite' => 0,
    #           'mem' => 22487040,
    #           'type' => 'lxc',
    #           'cpus' => 1
    #     },
    #     [...]
    #   }
    def lxc_get
      data = http_action_get "nodes/#{@node}/lxc"
      ve_list = {}
      data.each do |ve|
        ve_list[ve['vmid']] = ve
      end
      ve_list
    end

    # Create CT container
    #
    # :call-seq:
    #   lxc_post(ostemplate, vmid) -> String
    #   lxc_post(ostemplate, vmid, options) -> String
    #
    # Return a String as task ID
    #
    # Examples:
    #
    #   lxc_post('ubuntu-10.04-standard_10.04-4_i386', 200)
    #   lxc_post('ubuntu-10.04-standard_10.04-4_i386', 200, {'hostname' => 'test.test.com', 'password' => 'testt' })
    #
    # Example return:
    #
    #   UPID:localhost:000BC66A:1279E395:521EFC4E:vzcreate:200:root@pam:
    #
    ##### TODO URLENCODE 
    def lxc_post(ostemplate, vmid, config = {})
      config['vmid'] = vmid
      config['ostemplate'] = "local%3Avztmpl%2F#{ostemplate}.tar.gz"
      vm_definition = config.to_a.map { |v| v.join '=' }.join '&'
      http_action_post("nodes/#{@node}/lxc", vm_definition)
    end

    # Delete CT
    #
    # :call-seq:
    #   lxc_delete(vmid) -> String
    #
    # Return a string as task ID
    #
    # Example:
    #
    #   lxc_delete(200)
    #
    # Example return:
    #
    #   UPID:localhost:000BC66A:1279E395:521EFC4E:vzdelete:200:root@pam:
    #
    def lxc_delete(vmid)
      http_action_delete "nodes/#{@node}/lxc/#{vmid}"
    end

    # Get CT status
    #
    # :call-seq:
    #   lxc_delete(vmid) -> String
    #
    # Return a string as task ID
    #
    # Example:
    #
    #   lxc_delete(200)
    #
    # Example return:
    #
    #   UPID:localhost:000BC66A:1279E395:521EFC4E:vzdelete:200:root@pam:
    #
    def lxc_status(vmid)
      http_action_get "nodes/#{@node}/lxc/#{vmid}/status/current"
    end

    # Start CT
    #
    # :call-seq:
    #   lxc_start(vmid) -> String
    #
    # Return a string as task ID
    #
    # Example:
    #
    #   lxc_start(200)
    #
    # Example return:
    #
    #   UPID:localhost:000BC66A:1279E395:521EFC4E:vzstart:200:root@pam:
    #
    def lxc_start(vmid)
      http_action_post "nodes/#{@node}/lxc/#{vmid}/status/start"
    end

    # Stop CT
    #
    # :call-seq:
    #   lxc_stop(vmid) -> String
    #
    # Return a string as task ID
    #
    # Example:
    #
    #   lxc_stop(200)
    #
    # Example return:
    #
    #   UPID:localhost:000BC66A:1279E395:521EFC4E:vzstop:200:root@pam:
    #
    def lxc_stop(vmid)
      http_action_post "nodes/#{@node}/lxc/#{vmid}/status/stop"
    end

    # Shutdown CT
    #
    # :call-seq:
    #   lxc_shutdown(vmid) -> String
    #
    # Return a string as task ID
    #
    # Example:
    #
    #   lxc_shutdown(200)
    #
    # Example return:
    #
    #   UPID:localhost:000BC66A:1279E395:521EFC4E:vzshutdown:200:root@pam:
    #
    def lxc_shutdown(vmid)
      http_action_post "nodes/#{@node}/lxc/#{vmid}/status/shutdown"
    end

    # Get CT config
    #
    # :call-seq:
    #   lxc_config(vmid) -> String
    #
    # Return a string as task ID
    #
    # Example:
    #
    #   lxc_config(200)
    #
    # Example return:
    #
    #   {
    #     'quotaugidlimit' => 0,
    #     'disk' => 0,
    #     'ostemplate' => 'ubuntu-10.04-standard_10.04-4_i386.tar.gz',
    #     'hostname' => 'test.test.com',
    #     'nameserver' => '127.0.0.1 192.168.1.1',
    #     'memory' => 256,
    #     'searchdomain' => 'domain.com',
    #     'onboot' => 0,
    #     'cpuunits' => 1000,
    #     'swap' => 256,
    #     'quotatime' => 0,
    #     'digest' => 'e7e6e21a215af6b9da87a8ecb934956b8983f960',
    #     'cpus' => 1,
    #     'storage' => 'local'
    #   }
    #
    def lxc_config(vmid)
      http_action_get "nodes/#{@node}/lxc/#{vmid}/config"
    end

    # Set CT config
    #
    # :call-seq:
    #   lxc_config_set(vmid, parameters) -> Nil
    #
    # Return nil
    #
    # Example:
    #
    #   lxc_config(200, { 'swap' => 2048 })
    #
    # Example return:
    #
    #   nil
    #
    def lxc_config_set(vmid, data)
      http_action_put("nodes/#{@node}/lxc/#{vmid}/config", data)
    end

end

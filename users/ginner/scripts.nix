{ config, pkgs, lib, ... }:

{
  home.packages = [

    (pkgs.writeShellApplication {
      name = "mailias";
      
      runtimeInputs = with pkgs; [
        coreutils
        wl-clipboard
      ];

      text = ''
        #!/usr/bin/env bash
        
        cmd=$(basename "''${0}")

        # Function to display usage
        usage() {
          echo "Usage: ''${cmd} <from_alias> <to_address>"
          echo "Example: ''${cmd} from@myalias.com to@receiver.net"
          exit 1
        }

        # Check if we have the correct number of arguments
        if [ $# -ne 2 ]; then
          usage
        fi

        # Get the input parameters
        from_alias="''${1}"
        to_address="''${2}"

        # Extract the parts of the from_alias
        from_user=$(echo "''${from_alias}" | cut -d@ -f1)
        from_domain=$(echo "''${from_alias}" | cut -d@ -f2)

        # Replace @ with = in the to_address
        formatted_to="''${to_address//@/=}"

        # Construct the final address
        final_address="''${from_user}+''${formatted_to}@''${from_domain}"

        # Output the result and copy to clipboard
        echo "''${final_address}"
        echo "''${final_address}" | wl-copy
        echo "Address copied to clipboard!"
      '';
    })

    (pkgs.writeShellApplication {
      name = "sermail";
      
      runtimeInputs = with pkgs; [
        coreutils
        wl-clipboard
      ];

      text = ''
        #!/usr/bin/env bash
        
        cmd=$(basename "''${0}")
        # Function to display usage
        usage() {
          echo "Usage: ''${cmd} <service-name> <domain>"
          echo "Example: ''${cmd} spotify gmail.com"
          exit 1
        }

        # Function to generate random string
        generate_random() {
          chars="abcdefghijklmnopqrstuvwxyz0123456789"
          for ((i=0; i<5; i++)); do
            echo -n "''${chars:RANDOM%36:1}"
          done
        }

        # Check if we have the correct number of arguments
        if [ $# -ne 2 ]; then
          usage
        fi

        # Get the input parameters
        service_name="''${1}"
        domain="''${2}"

        # Generate random characters
        random_chars=$(generate_random)

        # Construct the final address
        final_address="''${service_name}_''${random_chars}@''${domain}"

        # Output the result and copy to clipboard
        echo "Generated email: ''${final_address}"
        echo "''${final_address}" | wl-copy
        echo "Address copied to clipboard!"

      '';
    })
  ];
}

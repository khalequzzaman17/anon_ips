# anon_ips
A public Github repository where the IP addresses are used to hack websites by the hackers will be listed.

---

# csf (script)
This script is designed to facilitate automatic denylisting of Anon IPs in ConfigServer Security & Firewall (CSF).

## Options
|  Opt  |    Options    | Description|
| :---: | ---------  | ---  |
| `-U` |`--update`|   Add/Update anon_ips to csf.deny list|
| `-R` |`--restore`|   Restore csf.deny to origin|
| `-H` |`--help`  |   Display help messages|

## Usage
1. Download and give permission to the script
    ```
    wget -q https://raw.githubusercontent.com/khalequzzaman17/anon_ips/main/csf.sh -P /opt/
    ```
    ```
    mv -f /opt/csf.sh /opt/csf-auto-update.sh && chmod +x /opt/csf-auto-update.sh
    ```

2. Add a rule to the cronjob \
Edit cronjob with the `crontab -e` command, and insert a rule similar to the following. This example will run every day at 00:00:

    ```
    0 0 * * * /opt/csf-auto-update.sh
    ```

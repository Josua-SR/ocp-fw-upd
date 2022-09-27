# Validation of FW Upgrade

To validate reliability of the process, 10 new X710 OCP cards were upgraded sequentially in the same physical half-twins unit.

## Runs

- 0: `./validate.sh 0`
   - previously updated card
   - new card
   - sfp direct-attach copper loop ports 1&3+2&4

- 1 `./validate.sh 1`
   - sfp direct-attach copper loop ports 1&3+2&4
   - new card
   - Serial-Number: 6805CABFAFC00081920ADK35347002

- 2 `./validate.sh 2`
   - sfp direct-attach copper loop ports 1&3+2&4
   - new card
   - Serial-Number: 6805CABFACB00081920ADK35347002

- 3 `./validate.sh 3`
   - sfp direct-attach copper loop ports 1&3+2&4
   - new card
   - Serial-Number: 6805CABFAD500081920ADK35347002

- 4 `./validate.sh 4`
   - sfp direct-attach copper loop ports 1&3+2&4
   - new card
   - Serial-Number: 6805CABFB2280081920ADK35347002

- 5 `./validate.sh 5`
   - sfp direct-attach copper loop ports 1&3+2&4
   - new card
   - Serial-Number: 6805CABFB4F80081920ADK35347002

- 6 `./validate.sh 6`
   - sfp direct-attach copper loop ports 1&3+2&4
   - new card
   - Serial-Number: 6805CABFB2380081920ADK35347002

- 7: `./validate.sh 7`
   - sfp fiber modules 2x10G loop ports 2&4
   - new card
   - Serial-Number: 6805CABFB4E80081920ADK35347002

- 8: `./validate.sh 8`
   - sfp fiber modules 2x10G loop ports 2&4
   - new card
   - Serial-Number: 6805CABFB0400081920ADK35347002

- 9: `./validate.sh 9`
   - sfp fiber modules 2x10G loop ports 2&4
   - new card
   - Serial-Number: 6805CABFB0680081920ADK35347002

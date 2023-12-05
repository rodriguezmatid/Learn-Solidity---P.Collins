# crea este directorio
mkdir carpet_name
# te lleva a esta carpeta
code carpet_name/ 

# inicialización de proyecto con foundry
forge init
# compila y testea el código
forge test

# install the chainlink library
forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-comit

# test with visibility in the console
forge test -vv

forge test --match-test testOnlyOwnerCanWithdraw 
# testea todos los test
forge snapshot
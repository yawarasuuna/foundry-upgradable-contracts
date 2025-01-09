-include .env

.PHONY: all test test-zk clean deploy fund help install snapshot format anvil install deploy deploy-zk deploy-zk-sepolia deploy-sepolia verify

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
DEFAULT_ZKSYNC_LOCAL_KEY := 0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install cyfrin/foundry-devops@0.2.2 --no-commit && forge install foundry-rs/forge-std@v1.8.2 --no-commit && forge install openzeppelin/openzeppelin-contracts@v5.0.2 --no-commit

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

test-zk :; foundryup-zksync && forge test --zksync && foundryup

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

deploy:
	@forge script script/DeployBox.s.sol:DeployBox --rpc-url http://localhost:8545 --account $(ANVIL_ACCOUNT) --broadcast

deploy-sepolia:
	@forge script script/DeployBox.s.sol:DeployBox --rpc-url $(SEPOLIA_RPC_URL) --account $(DEV_ACCOUNT) --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --verify

deploy-zk:
	@forge script script/DeployBox.s.sol:DeployBox --rpc-url http://127.0.0.1:8011 --private-key $(DEFAULT_ZKSYNC_LOCAL_KEY) --legacy --zksync

deploy-zk-sepolia:
	@forge script script/DeployBox.s.sol:DeployBox --rpc-url $(ZKSYNC_SEPOLIA_RPC_URL) --account $(ACCOUNT) --legacy --zksync

upgrade:
	@forge script script/UpgradeBox.s.sol:UpgradeBox --rpc-url http://localhost:8545 --account $(ACCOUNT) --broadcast

upgrade-sepolia:
	@forge script script/UpgradeBox.s.sol:UpgradeBox --rpc-url $(SEPOLIA_RPC_URL) --account $(DEV_ACCOUNT) --etherscan-api-key $(ETHERSCAN_API_KEY) --broadcast --verify

upgrade-zk:
	@forge script script/UpgradeBox.s.sol:UpgradeBox --rpc-url http://127.0.0.1:8011 --private-key $(DEFAULT_ZKSYNC_LOCAL_KEY) --legacy --zksync

upgrade-zk-sepolia:
	@forge script script/UpgradeBox.s.sol:UpgradeBox --rpc-url $(ZKSYNC_SEPOLIA_RPC_URL) --account $(ACCOUNT) --legacy --zksync
	
# verify:
	# @forge verify-contract --chain-id 11155111 --num-of-optimizations 200 --watch --constructor-args 0x00000000000000000000000000000000000000000000d3c21bcecceda1000000 --etherscan-api-key $(ETHERSCAN_API_KEY) --compiler-version v0.8.19+commit.7dd6d404 0x089dc24123e0a27d44282a1ccc2fd815989e3300 src/OurToken.sol:OurToken
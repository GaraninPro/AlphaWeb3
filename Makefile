-include .env

deploy-sepolia:
	forge script script/DeployFundMe.s.sol --rpc-url $(RPC2) --private-key $(KEY2) --broadcast --verify --etherscan-api-key $(SCAN) -vvvv

fundContract:
	forge script script/interactions.s.sol:fundFundMe --rpc-url $(RPC2) --private-key $(KEY2) --broadcast

withdrawContract:
	forge script script/interactions.s.sol:withdrawFundMe --rpc-url $(RPC2) --private-key $(KEY2) --broadcast

	////////////////////////////////////////////////////////////////////////////////
deploy-anvil:
	forge script script/DeployFundMe.s.sol --rpc-url $(RPC) --private-key $(KEY) --broadcast
		
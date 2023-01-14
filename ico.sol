 pragma solidity 0.4.23;

 import "https://github.com/ConsenSysMesh/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol";
 import "https://github.com/ConsenSysMesh/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol";

  contract InitialCoinOffering{
      // we are using the safemath library here
      using SafeMath for uint256;

      // our token will be erc20
      ERC20 public token;

      // the wallet where we get funds
      address public wallet;
      
      // rate per wei
      uint256 public rate;

      // amount of wei raised so far
      uint256 public weiRaised;

      constructor(ERC20 _token, address _wallet, uint256 _rate) public {
        // put checks
        require(_rate > 0);
        require(_wallet != address(0));
        require(_token != address(0));

        token = _token;
        wallet = _wallet;
        rate = _rate;
      }

      function () external payable {
          buyTokens(msg.sender);
      }

      function buyTokens(address _beneficiary) public payable {
        
        uint256 weiAmount = msg.value;
        _preValidatePurchase(_beneficiary, weiAmount);
        // @dev do no panic if the compiler throws an error here
        // we will still define the preValidatePurchase later
        
        // the amount of token to be minted
        uint256 tokens = _getTokenAmount(weiAmount);

        //update the state

        weiRaised = weiRaised.add(weiAmount);

        _processPurchase(_beneficiary, tokens);
         
         _updatePurchasingState(_beneficiary, weiAmount);
         
         _sendFunds();

         _postValidatePurchase(_beneficiary, weiAmount);
      }

      function _preValidatePurchase(address _beneficiary, uint256 weiAmount) internal {
        require(_beneficiary != address(0));
        require(weiAmount != 0);
      }

      function _postValidatePurchase(address _beneficiary, uint256 weiAmount) internal {

      }

      function _transferTokens(address _beneficiary, uint256 _tokenAmount) internal {
           token.transfer(_beneficiary, _tokenAmount);
      }

      function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
           _transferTokens(_beneficiary, _tokenAmount);
      }

      function _updatePurchasingState(address _beneficiary, uint256 _tokenAmount) internal {
           token.transfer(_beneficiary, _tokenAmount);
      }

      function _getTokenAmount(uint256 _weiAmount) internal view returns(uint256){
       return _weiAmount.mul(rate);
      }

      function _sendFunds() internal {
          wallet.transfer(msg.value);
      }



     

  }

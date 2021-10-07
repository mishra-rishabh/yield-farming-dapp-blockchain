pragma solidity >= 0.5.0 <= 0.9.0 ;

import "./DappToken.sol" ;
import "./DaiToken.sol" ;

contract TokenFarm {
  // state variables
  string public name = "Dapp Token Farm" ;
  address public owner ;
  DappToken public dappToken ;
  DaiToken public daiToken ;

  address[] public stakers ;
  mapping( address => uint ) public stakingBalance ;
  mapping( address => bool ) public hasStaked ;
  mapping( address => bool ) public isStaking ;

  constructor( DappToken _dappToken , DaiToken _daiToken ) public {
    dappToken = _dappToken ;
    daiToken = _daiToken ;
    owner = msg.sender ;
  }

  // 1. staking tokens ( deposit )
  function stakeTokens( uint _amount ) public {
    // check that the person’s balance actually exists when they stake tokens
    require( _amount > 0 , "Amount can't be 0" ) ;

    // transfer mock dai tokens to this contract for staking
    daiToken.transferFrom( msg.sender , address( this ) , _amount ) ;

    // update staking balance
    stakingBalance[ msg.sender ] += _amount ;
    
    // add users to stakers array only if they havn't staked already
    if( !hasStaked[ msg.sender ] ) {
      stakers.push( msg.sender ) ;
    }

    // update staking status 
    isStaking[ msg.sender ] = true ;
    hasStaked[ msg.sender ] = true ;
  }

  // 3. unstaking tokens ( withdraw )
  function unstakeTokens() public {
    // fetch staking balance
    uint balance = stakingBalance[ msg.sender ] ;

    // require amount greater that zero
    require( balance > 0 , "Staking balance can't be 0" ) ;

    // transfer Mock Dai tokens to this contract for staking
    daiToken.transfer( msg.sender , balance ) ;

    // reset the staking balance
    stakingBalance[ msg.sender ] = 0 ;

    // update staking status
    isStaking[ msg.sender ] = false ; 
  }

  // 2. issuing tokens
  function issueTokens() public {
    // only owner can call the function
    require( msg.sender == owner , "Caller must be the owner" ) ;

    // issue tokens to all the stakers
    for( uint i = 0 ; i < stakers.length ; i++ ) {
      // find out how many tokens they have staked and issue them that same amount of dapp tokens
      address recipient = stakers[ i ] ;
      uint balance = stakingBalance[ recipient ] ;
      
      if( balance > 0 ) {
        dappToken.transfer( recipient , balance ) ;
      }
    }
  }
}

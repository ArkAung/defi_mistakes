function depositfor(
	 address token,
	 uint256 _amount,
	 address user
) public {
	strategy.beforeDeposit();
	uint256 _pool = balance();
	IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);
	earn();
	uint256 after = balance();
	_amount = after.sub(_pool); // Additional check for deflationary tokens
	uint256 shares = 0;
	if (totalSupply() == 0) {
	   shares = _amount;
	} else {
	  shares = (_amount.mul(totalSupply())).div(_pool);
	}
	_mint(user, shares);
}
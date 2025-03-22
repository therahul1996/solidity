// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract UserDetails {
    struct User {
        string name;
        uint256 age;
        string email;
        bool exist;
    }
    struct UserSummary {
        address userAddress;
        string name;
        string email;
    }
    mapping(address => User) private users;

    address[] private userAddress;
    address public owner;

    event UserDetailsAdded(
        address indexed userAddress,
        string name,
        uint256 age,
        string email
    );
    event UserDetailsUpdaate(
        address indexed userAddress,
        string name,
        uint256 age,
        string email
    );

    modifier onlyRegisterUser() {
        require(users[msg.sender].exist, "User not register yet!");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner have access");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addUserDetails(
        string memory _name,
        uint256 _age,
        string memory _email
    ) external {
        require(!users[msg.sender].exist, "User already registered");
        users[msg.sender] = User(_name, _age, _email, true);
        userAddress.push(msg.sender);
        emit UserDetailsAdded(msg.sender, _name, _age, _email);
    }

    function getUserDetails(
        address _userAddress
    ) external view returns (string memory, uint256, string memory) {
        require(users[_userAddress].exist, "User not registered");
        User memory user = users[_userAddress];
        return (user.name, user.age, user.email);
    }

    function updateUserDetails(
        string memory _name,
        uint256 _age,
        string memory _email
    ) external onlyRegisterUser {
        User storage user = users[msg.sender];
        user.name = _name;
        user.age = _age;
        user.email = _email;

        emit UserDetailsUpdaate(msg.sender, _name, _age, _email);
    }

    function getAllUsers()
        external
        view
        onlyOwner
        returns (UserSummary[] memory)
    {
        uint256 totalUsers = userAddress.length;
        UserSummary[] memory summarise = new UserSummary[](totalUsers);

        for (uint256 i = 0; i < totalUsers; i++) {
            address userAddr = userAddress[i];
            User memory user = users[userAddr];
            summarise[i] = UserSummary(userAddr, user.name, user.email);
        }
        return summarise;
    }
}

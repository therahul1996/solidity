// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Twitter {
    // uint16 constant MAX_LENGTH = 280;
    uint16 public MAX_LENGTH = 280;
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }
    mapping(address => Tweet[]) public tweets;
    address public owner;

    event TweetCreated(
        uint256 id,
        address author,
        string content,
        uint256 timestamp
    );

    event TweetLiked(
        address liker,
        address tweetAuthor,
        uint256 tweetId,
        uint256 newLikeCount
    );

    event TweetUnliked(
        address liker,
        address tweetAuthor,
        uint256 tweetId,
        uint256 newLikeCount
    );

    constructor() {
        owner = msg.sender;
    }

    function createTweet(string memory _tweet) public {
        require(bytes(_tweet).length <= MAX_LENGTH, "Length is to large");
        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });
        tweets[msg.sender].push(newTweet);

        emit TweetCreated(
            newTweet.id,
            newTweet.author,
            newTweet.content,
            newTweet.timestamp
        );
    }

    function likeTweet(address author, uint256 _id) external {
        require(tweets[author][_id].id == _id, "Tweet does not exit");
        tweets[author][_id].likes++;
        emit TweetLiked(msg.sender, author, _id, tweets[author][_id].likes);
    }

    function unlikeTweet(address author, uint256 _id) external {
        require(tweets[author][_id].id == _id, "Tweet does not exit");
        require(tweets[author][_id].likes > 0, "There are no likes");

        tweets[author][_id].likes--;

        emit TweetUnliked(msg.sender, author, _id, tweets[author][_id].likes);
    }

    function getTotalLikes(address _author) external view returns (uint256) {
        uint256 totalLikes;
        for (uint256 i = 0; i < tweets[_author].length; i++) {
            totalLikes += tweets[_author][i].likes;
        }
        return totalLikes;
    }

    function getTweet(
        address _owner,
        uint256 _i
    ) public view returns (Tweet memory) {
        return tweets[_owner][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function changeTweetLength(uint16 newTweetLength) public onlyOwner {
        MAX_LENGTH = newTweetLength;
    }
}

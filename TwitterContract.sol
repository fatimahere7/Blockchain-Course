// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TwitterContract{

    // uint16 constant MAX_TWEET_LENGTH = 280;
    uint16 public MAX_TWEET_LENGTH = 280;

    event TweetCreated(uint256 id , address author , string content , uint256 timestamp);
    event TweetLiked(address liker , address tweetAuthor , uint256 tweetId , uint256 newLikedCount);
    event TweetUnLiked(address unliker , address tweetAuthor , uint256 tweetId , uint256 newLikedCount);
    struct Tweet{
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }
    // Twitter[] public tweets;
    address public owner;
    constructor(){
        owner = msg.sender;
    }

    // mapping(address => string) public tweets;
    mapping(address => Tweet[]) public tweets;

    modifier onlyOwner(){
        require(msg.sender == owner, "YOU ARE NOT THE OWNER");
        _;
    } 
    function changeTweetLength(uint16 newLength) public onlyOwner{
        MAX_TWEET_LENGTH = newLength;
    }

    function createTweet(string memory _tweet) public {
        // tweets[msg.sender].push(_tweet);
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH , "Tweet is too long brrrr");
        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author : msg.sender,
            content : _tweet,
            timestamp : block.timestamp,
            likes : 0
        });
        tweets[msg.sender].push(newTweet);
        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);

    }

    function likeTweet(uint256 id , address author) external {
        require(tweets[author][id].id == id, "Tweet Doesnt Exist");

        tweets[author][id].likes++;
        emit TweetLiked(msg.sender, author, id, tweets[author][id].likes);
    }

    function unLikeTweet(uint256 id , address author) external {
        require(tweets[author][id].id == id, "Tweet Doesnt Exist");
        require(tweets[author][id].likes > 0, "Tweet has no Likes");
        tweets[author][id].likes--;
        emit TweetUnLiked(msg.sender, author ,id , tweets[author][id].likes);
    }



    function getTweet(address _owner ,uint _i) public view returns(Tweet memory){
        return tweets[_owner][_i];
    }
    function getAllTweets(address _owner) public view returns (Tweet[] memory){
        return tweets[_owner];
    }
}
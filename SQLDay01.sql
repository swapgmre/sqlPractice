re because what that does is it allows us to do something before it's saved in

45
00:02:59,810 --> 00:03:01,070
the database.

46
00:03:01,550 --> 00:03:01,970
Okay.

47
00:03:01,970 --> 00:03:06,050
So anything that's that has to do with the user.

48
00:03:06,610 --> 00:03:12,700
If we're saving something to the database, if we use pre, then this will run before because obviously

49
00:03:12,700 --> 00:03:16,870
we want to hash the password before it gets saved to the database.

50
00:03:16,900 --> 00:03:22,630
You can also do post which would do something after, but obviously we need to do this before.

51
00:03:23,080 --> 00:03:26,680
And there's different actions that you can do before or whatever.

52
00:03:26,680 --> 00:03:28,990
In this case we want to do before save.

53
00:03:29,020 --> 00:03:30,010
So we pass in.

54
00:03:30,010 --> 00:03:30,850
Save.

55
00:03:31,060 --> 00:03:36,370
All right, Then we're going to go into the function body and we're going to say if.

56
00:03:39,080 --> 00:03:39,890
Let's say.

57
00:03:39,890 --> 00:03:44,960
If not, this dot is modified.

58
00:03:48,010 --> 00:03:54,280
Okay, So what this is doing here, if this is not modified password, then we're just going to call

59
00:03:54,280 --> 00:03:59,320
the next piece of middleware because that's what this is, is middleware for Mongoose.

60
00:03:59,320 --> 00:04:04,210
So if we're just saving some user data, but we're not dealing with the password, then it's just going

61
00:04:04,210 --> 00:04:05,020
to move on.

62
00:04:05,020 --> 00:04:06,340
It's just going to next.

63
00:04:06,670 --> 00:04:07,030
All right.

64
00:04:07,030 --> 00:04:12,850
So outside of that, though, if we are modifying the password, then we're first going to generate

65
00:04:12,850 --> 00:04:20,860
a salt with the bcrypt method of gin salt, and then we're going to set this dot password, this pertaining

66
00:04:20,890 --> 00:04:24,460
to the current user that we're saving.

67
00:04:24,460 --> 00:04:27,490
And then we're going to get the password field.

68
00:04:27,490 --> 00:04:33,220
And instead of setting it to just the plain text, we're going to set it to a hashed password using

69
00:04:33,220 --> 00:04:39,670
the hash method from the Bcrypt package, which takes in the password and then the salt, and then it

70
00:04:39,670 --> 00:04:46,270
will create a hash and it'll get saved to the database because now we're we're trading basically trading

71
00:04:46,270 --> 00:04:50,180
this password that's plain text that's passed in from the form.

72
00:04:50,180 --> 00:04:57,590
We're trading it for this hashed password before it's saved pre save.

73
00:04:58,080 --> 00:05:00,180
So hopefully that makes sense.

74
00:05:00,510 --> 00:05:03,560
So let's make sure that this file is saved.

75
00:05:03,570 --> 00:05:11,640
And what we want to do once that user is registered is we want to authenticate, basically, we want

76
00:05:11,640 --> 00:05:19,860
to create our Json web token and we want to create our Http only cookie, just like we did above, just

77
00:05:19,860 --> 00:05:21,420
like we did right here.

78
00:05:21,780 --> 00:05:22,770
Now.

79
00:05:23,340 --> 00:05:29,820
Instead of just putting the same code because I would do the same exact thing, I'd put the user ID

80
00:05:29,820 --> 00:05:35,410
into a Json web token and then save it to a cookie instead of repeating ourselves.

81
00:05:35,430 --> 00:05:42,360
Let's create a separate file for this or a separate function for this.

82
00:05:42,360 --> 00:05:46,290
So let's go into let's see, do we have a utils here?

83
00:05:47,260 --> 00:05:50,200
Or that that was in the front end right where we had our.

84
00:05:50,200 --> 00:05:56,350
Yeah, we have a front end utils, but let's go into the back end and let's create a new folder called

85
00:05:56,350 --> 00:05:57,520
utils.

86
00:05:59,180 --> 00:06:06,950
And in this utils let's create a file called generate token dot js.

87
00:06:08,810 --> 00:06:09,260
All right.

88
00:06:09,260 --> 00:06:13,640
And then in this file, basically we're going to do this.

89
00:06:13,640 --> 00:06:19,610
So we need to bring in import Json web token into this file.

90
00:06:20,510 --> 00:06:23,120
And then let's create a function.

91
00:06:23,120 --> 00:06:25,550
We'll say const, generate.

92
00:06:27,500 --> 00:06:29,450
Generate token.

93
00:06:30,000 --> 00:06:32,760
And it's going to take in two things, actually.

94
00:06:32,760 --> 00:06:39,750
It's going to take in the response because we are going to need to use resort cookie and then it's also

95
00:06:39,750 --> 00:06:44,790
going to take in the user ID, let's call it user ID like that.

96
00:06:45,240 --> 00:06:45,720
Okay.

97
00:06:45,720 --> 00:06:52,620
And then inside the function body here, I'm going to grab what we have in the auth.

98
00:06:53,160 --> 00:07:00,120
So where we're defining the token and where we're setting the cookie, I'm going to just cut that.

99
00:07:01,120 --> 00:07:01,570
Okay.

100
00:07:01,570 --> 00:07:05,500
And then in generate token, we'll go ahead and paste that in.

101
00:07:05,860 --> 00:07:14,140
And now let's see, instead of setting user ID to this, we want to set it to the ID that's being passed

102
00:07:14,140 --> 00:07:16,000
in, which is the same name as this.

103
00:07:16,000 --> 00:07:18,910
So we can actually just get rid of that.

104
00:07:20,010 --> 00:07:21,020
That should work.

105
00:07:21,170 --> 00:07:25,510
And let's see down here, we're setting JWT.

106
00:07:25,520 --> 00:07:28,100
I don't think we need to change anything here.

107
00:07:28,630 --> 00:07:29,650
Yeah, that should be good.

108
00:07:29,650 --> 00:07:35,470
Now we just want to export, so we're going to export as default generate token.

109
00:07:37,230 --> 00:07:43,230
So now what we can do is in our user controller, we can bring this in.

110
00:07:44,090 --> 00:07:45,170
So right here.

111
00:07:45,170 --> 00:07:49,100
And we're not going to need to bring in JWT anymore because we're not using it here.

112
00:07:49,100 --> 00:07:54,860
So let's instead import generate token from our utility file.

113
00:07:55,690 --> 00:08:03,100
And then to use it, we're just going to go where we just cut that code from right above the this res.json

114
00:08:03,100 --> 00:08:05,740
and we're going to call generate token.

115
00:08:05,740 --> 00:08:11,290
We're going to pass in the response and we're going to pass in the user ID, Okay?

116
00:08:11,290 --> 00:08:14,980
And then here we're just going to respond the same way we did.

117
00:08:15,510 --> 00:08:22,380
Now what we can do is use this generate token down in the register as well.

118
00:08:23,190 --> 00:08:25,290
So we want to put this.

119
00:08:26,230 --> 00:08:28,930
Uh, right after here, right after we check for the user.

120
00:08:28,930 --> 00:08:30,730
Right before the response.

121
00:08:31,400 --> 00:08:33,440
So now we're not repeating ourselves.

122
00:08:33,440 --> 00:08:35,510
We're sticking to the dry principle.

123
00:08:35,510 --> 00:08:43,370
And instead of having all this code twice, we have a single function that we can call in both places.

124
00:08:43,400 --> 00:08:45,440
And now we can test the register.

125
00:08:45,440 --> 00:08:50,360
So let's come over here, let's go to register and we're going to go into the body.

126
00:08:51,690 --> 00:08:54,210
And let's add a name.

127
00:08:54,210 --> 00:08:55,560
So I'm just going to.

128
00:08:56,460 --> 00:09:00,210
Put my own name and then an email.

129
00:09:00,300 --> 00:09:05,520
I'll just say Brad at email and then a password.

130
00:09:07,190 --> 00:09:10,060
I'll just do one, two, three, four, five, six.

131
00:09:10,070 --> 00:09:11,930
And now let's send.

132
00:09:11,930 --> 00:09:15,530
And you can see we get back our user, our user was created.

133
00:09:15,530 --> 00:09:18,950
It was given an ID, and now we have our cookie set.

134
00:09:19,040 --> 00:09:24,050
So I should be able to go to my get user profile, which is a protected route and send.

135
00:09:24,050 --> 00:09:27,590
And that works because I'm logged in because I just registered.

136
00:09:28,890 --> 00:09:29,340
Okay.

137
00:09:29,340 --> 00:09:35,100
Now, if I go to log out and I send we get logged out successfully.

138
00:09:35,100 --> 00:09:41,730
If I try to go back to get my profile, I can't because I'm not I'm no longer logged in, but I am registered.

139
00:09:42,000 --> 00:09:44,220
And you can also check if you want.

140
00:09:44,220 --> 00:09:45,480
You can check through Compass.

141
00:09:45,480 --> 00:09:47,100
I just need to reload.

142
00:09:48,070 --> 00:09:49,390
The data here.

143
00:09:50,050 --> 00:09:53,800
And now you can see Brad Travis is now a user.

144
00:09:53,800 --> 00:09:55,840
And my password, of course, is hashed.

145
00:09:57,440 --> 00:09:57,770
Okay.

146
00:09:57,770 --> 00:09:59,000
So, so far, so good.

147
00:09:59,000 --> 00:10:05,810
Now, the next in the next video, I want to actually make these profile endpoints work.

148
00:10:05,810 --> 00:10:08,260
So I want to be able to get the user profile.

149
00:10:08,270 --> 00:10:14,510
I also want to be able to update the user profile if we want to change, you know, change some user

150
00:10:14,510 --> 00:10:15,170
data.

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 1
00:00:00,230 --> 00:00:05,270
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
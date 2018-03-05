# NFL Fantasy Auction

Application I built to allow users to conduct an auction style fantasy draft. Users bid on fantasy football players live and see their interface update in real time without refreshing the page as other users make bids. Players' historical statistics and attributes are graphed 

Live website running at: https://bt-auction.herokuapp.com/ (Account will need to be created to login).

** In process of updating to React JS views **

Technologies used:
* Ruby on Rails 5
* Devise Gem 
* Action Cable (Websockets)
* Chartkick graphing
* JQuery
* AJAX Remote Forms
* Heroku


### Features:

### Live Draft in Single Page Application
![Live Draft](https://i.imgur.com/NynAoqs.png)
Websockets sub and push created with Action Cable and JQuery (switching to React soon...) allow live update as auction proceeds, no refreshing the page.

### Auctioneer Control:
![Auctioneer](https://i.imgur.com/knBAtvv.png)
Auctioneer has full control of auction.

### Informative Graphs:
![Graphs](https://i.imgur.com/OKvaaTi.png)
See statistics plotted in real time and use them to make informed decisions. 

### NFL API Updates:
![API](https://i.imgur.com/2jx9FpF.png)
Top drafted players list updates from NFL.com's API source.


## Local Installation:

1. Clone github branch:
> git clone git@github.com:Arithmetics/auction.git

2. Install:
> bundle install

3. Update seeds.rb file (if neccessary)
> rails db:migrate
(optional)
> rails db:seed

4. Run tests
> rails t

## Comments:

This is the most complex app I have built, and also the one I am most proud of. The ability to set up web sockets is really funand useful, and graphing histoical data for use in fantasy sports is something I am personally very interested in. I look forward to continuing to push this project forward. 


### Future Improvements/Retrospective:

1. Add a system to invite/accept draft invites to controll what users can participate in draft.
2. Create a Leagues model, that own many drafts (draft belongs_to league).
3. Full implement React view componenets. 
4. Implement more data/graphical views for each player.
5. Once React implemented, Jasmine tests for frontend views.


# NFL Fantasy Auction

Application I built to allow users to conduct an auction style fantasy draft. Users bid on fantasy football players live and see their interface update in real time without refreshing the page as other users make bids. Players' historical statistics and attributes are graphed 

Live website running at: https://bt-nfl.herokuapp.com/ (Account will need to be created to login).

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

This was the second app I built. It was in the same vein as the NBA Contest Application but with a much better understanding of the Rails system and philosophy. I have very good backend test coverage, the rendering tests could use some work.


### Future Improvements/Retrospective:

1. Add a system to invite/accept draft invites to controll what users can participate in draft.
2. Create a Leagues model, that own many drafts (draft belongs_to league).
3. Full implement React view componenets. 
4. Implement more data/graphical views for each player.



# Coding Exercise

TRIBE is a marketplace that assists social media influencers monitise their social media posts through
paid collaborations with brands. A social media influencer is someone with an audience >3000 followers
on Instagram. Brands pay social media influencers to promote their products and services through
sponsored posts to the influencers social media channel and audience. The social media influencer can
choose to promote the brand using static images, through motion using video and audio.


**Usage**

It's easy! From your terminal, assuming you've already installed Ruby, you can run:

`ruby execute.rb YOUR_ORDER_STRING`

**Example Input:**

`10 IMG 15 FLAC 13 VID`

**Expected Output:**

```
10 IMG $800
 1 x 10 $800
15 FLAC $1957.50
 1 x 9 $1147.50
 1 x 6 $810
13 VID $2370
 2 x 5 $1800
 1 x 3 $570
```

**Example Input with error:**

`1 IMG 15 FLAC 13 VID`

*Here, no bundle would fit for the order request of only one (1) IMG.

**Expected Output:**

```
1 IMG $0
  No possible matches for this order.
15 FLAC $1957.50
 1 x 9 $1147.50
 1 x 6 $810
13 VID $2370
 2 x 5 $1800
 1 x 3 $570
```




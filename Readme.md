#WWDC'14  
First of all, I'd like to apologize: this is *way* below my standard of **both** code/app development/design and open-source quality.  
  
I'm writing this all retrospectively, so we get the advantage of hindsight.

###Scope
I initially had pretty big ambitions for this, but time… was not on my side. Thus, it became an intro view, with content dynamically sourced. Thus, there are a few main prongs that are important here:  
  
* JSON ——> View Hierarchy  
* Parallax Intro View/Automated Parallaxing Class

Thus, these gave rise to `content.json` and `KKRTimelineItem` et al. The dynamicism that the JSON-view hierarchy structure gives is comparable to the HTML approach Facebook took with their last-gen app, with native views. All without the overhead of converting from HTML to native. The constraints are relatively simple, while the internal object-graph is inanely complex at first glance. To understand, views get a UDID that are used to trace like a filepath.

The parallaxed class proxies as the delegate and essentially asks for views, automatically/lazily adds/removes them, and handles repositioning, with configurable speeds/rates.

###In Review  
* Design (of the app) is meh.  
* iOS 7 design as a whole is a mixed bag.
* Dig the intro card view.
* The JSONView thing is cool and I'm surprised it works so well.
* Parallax is nice.
* UIMotionEffects are nice to implement: a class to automatically take sizes into account and adjust the interpolation amount would be cool.
* Auto Layout turned out to not be that hard to do from scratch.
* UIPercentageDrivenTransitions are cool.
* Some of this deserves its own repo.

###Resolution  
* Pending feedback, I intend to make the dynamic JSONView class(es) their own project.
* The parallax view deserves to be its own class/repo.
* UIView could use some nice helper categories with UIMotionEffect. Perhaps a Gist.

###License
No warranty is provided for any code within this repository or related to the `Kolin Krewinkel.app` Xcode project for WWDC 2014. Code may be used for non-commerical/commericial purposes with attribution, unless it is with the intent to redistribute the original designs of this app (only concepts, such as the JSON view concept, or parallax management.) Basically, you can only scavenge from this, not use it as a basis.
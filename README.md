# InternetCats

Barebones demo on how to read the [CATAAS (Cats As A Service) API](https://cataas.com/) and display those sweet, sweet cat pics. Note: the API regularly goes down, so if it does not load, then this demo app will not work as intended.

<img src="https://github.com/AcidicSkittles/InternetCats/blob/main/home.png" width=25% height=25%> <img src="https://github.com/AcidicSkittles/InternetCats/blob/main/lebonk.png" width=25% height=25%>

## Architecture
* MVVM design pattern to separate business logic into testable view models. This allows us to dependency inject whatever behavior we desire into our business logic for testability. Want to create a mock network call for a unit test? No problem. Implement the ```NetworkServiceType``` protocol and mock away.
* Combine framework for easy binding and communication from view controller to view model.
* Network service layer that uses generic functions where you simply pass in the desired decodable type for your expected response object - no more need for functions for each and every endpoint request - only one will do the trick for them all!
* Abstraction layers between every service we would like to unit test.

## Features
* Filter cats by a tag that is loaded from the API
* Adjust the number of columns as you see fit in ```LayoutSettings.swift```
* Tap on a cat to show the owner (if one) and any tags associated with the cat
* iPad support and multi-orientation support


## API Pitfalls
I originally wanted to display small thumbnail versions of the cats in a large grid. The API allows you to specify a width parameter for images, but your width request generates the image on the fly. This causes the response time for a thumbnail version of a GIF to take exponentially longer than just downloading the full size image.

Some of the resized gifs also get garbled:

![Garbled](rV1MVEh0Af2Bm4O0.gif)

How could this be fixed? I personally would use [ImageMagick](https://imagemagick.org/) to coalesce the frames, then resize the GIF, then call ```OptimizeImageTransparency``` to restore the frame-by-frame transparency for the GIF. I believe the GIF is being resized and the transparencies are not being updated to reflect the frame size change - causing an odd ghosting effect.

As of 12/18/22 I experienced unexpected behavior trying to get paged results. You would expect the below URL to return images 10 - 20, but instead it returns 1000 images. As a result, paging does not necessarily work as expected, but it does technically work... it just gives you the next thousand images.

```https://cataas.com/api/cats?limit=10&skip=10```

The project maintainer does warn "Cataas is in under recovery mode" ¯\\_(ツ)_/¯

## Libraries Used via Cocoapods
* [Nuke](https://github.com/kean/Nuke)
Probably my favorite image loader that handles downloading and caching.
* [FLAnimatedImage](https://github.com/Flipboard/FLAnimatedImage)
Battle tested, pretty good GIF displaying engine.
* [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager)
Abstracts the absolute job it is to add a "Done" button to the iOS keyboard.


Happy coding!

#  Assignment 4

## Goals

I tried to see how good I could find cut points.

## Steps

1. Obviously, I first read the paper. It was a little confusing, but I kind of get the gist.
2. Get some stuff working. So, for this project, we need a SAT solver (Z3 was recommended), and since I want to find cut points, I need a way to parse a program. Since I like Swift, and I knew about SwiftSyntax. I went with that.
    1. Z3
        1. This was two step. First, I needed Z3 libraries on my machine, which was easy enough in that I just needed to use MacPorts to download and install it. Thankfully, I was already using MacPorts.
        2. Next I needed to add it to my project. I hadn't used Swift packages before, but this turned out to be fairly simple. Basically, I found an open source project that offered Z3 Swift bindings. Again, this was an easy Google search. Once I found that, I just needed to add a "package" to my project which mostly just involves pasting a URL into a panel in Xcode. Xcode then checks outs and builds all the required dependencies as part of your project.
    2. SwiftSyntax
        1. This was also pretty straight forward, as I just needed to once again add a package to my project.
3. The next part was to make sure things worked. This part was also pretty simple.
    1. For Z3, I just copied a simple example, and made sure the correct results were produced.
    2. For SwiftSyntax, I wrote a simple (but not correct ;) Swift program, and made sure SwiftSyntax could parse it into an AST
4. Next, I dove into doing something with the AST, and that's where I bogged down.
    1. The first issue is that SwiftSyntax isn't all that well documented. Thankfully, the source is documented, so you can jump into the source, and read through it, and read the method headers, and that helped a bit.
    2. However, that only got me a little way. I also found an online site that use SwiftSyntax to produce an AST you can explore graphically: https://swift-ast-explorer.com, and this helped a bit.
    3. Still, given that Swift is strongly typed, I was having issues figure out what types were what, so the next help was when it occurred to me that the unit tests of SwiftSyntax might be useful, and these actually were. They showed me some simple examples of how to properly extract information from the AST.
    4. This got me "finding" my function, and looked around the AST, but I still was having issues knowing what the object data actually contained, so I was still having issues.
    5. Finally, I noticed, when looking at the source, that the classes were all implementing the CustomReflectable protocol. I'd seen this before, but never paid it much attention, but seeing it used peaked my interest, and I looked into the protocol. This led me to implementing my "dump" function, and once I did that, I was able to start making some good progress.
    6. That being said, I didn't really make it all that far into what I wanted to do, as I'd spend a number of hours getting this far. However, I was able to walk the AST, find a function of interest, then walk it's code. I only got as far as recognizing it's declarations, but at least at this point, I feel like it wouldn't be hard to now start doing things like recognizing loops.
    
## Final Thoughts

I'd have kind of liked to get a little further along, but honestly, this paper was grabbing me as much as the previous papers. That made it hard for me to concentrate on the code. In otherwords, this project felt like kind of a slog. That being said, it wasn't without some interest, and I liked seeing how the authors used the SAT solver. I also liked playing around with SwiftSyntax, and figuring out how CustomReflectable could be used was also enlightening, even if not directly related to the contents of the actual paper.

I guess what I'm getting to is that I may not have learned as much about the application of the paper as I might have, but I learned a bunch of interesting things about using Swift.
    


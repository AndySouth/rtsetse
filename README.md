rtsetse
========================================================

rtsetse is (or will be) an R package for simulating tsetse fly populations.

It follows from Hat-Trick, an Excel based Tsetse model see rtsetse.org.

Development by Andy South in 2014. Do get in touch with comments or questions.

To develop a Hat-trick replacement I am following a modular programming approach, building a series of components that can be tested in isolation and can contribute to a useful, maintainable and modifiable tool. Within the 6 months available it will not be possible to provide all the functionality of the current Hat-Trick but it will be possible to provide a functioning model that can be built upon.

I have organised development in phases with each phase producing a testable deliverable. The components of each phase will be combined to produce a modular product. Some user-interface components for inputs and outputs will be developed within each phase. A later phase will work on how best to combine these and add to them to create a coherent tool.

All functions in the package are currently preceded by rt. There are functions called rtPhase[n]Test() which test the development phases as shown below.

* **Phase 1 : Population1**:  an age-structured a-spatial population simulation for tsetse
* **Phase 2 : Movement1**:  random movement independent of vegetation
* **Phase 3 : Feeding1**:  based on detection probabilities and number of hosts
* **Phase 4 : Map1**:  accepting vegetation, host and settlement maps
* **Phase 5 : Population2**:  combining previous phases to create a spatial popn simulation
* **Phase 6 : Control1**:  control by treated cattle, baits or aerial spraying
* **Phase 7 : UI1**:  combining previous phases with a user interface
* **Phase 8 : Tryp**:  adding infection of flies and hosts
* **Phase 9 : Movement2**:  movement dependent on vegetation

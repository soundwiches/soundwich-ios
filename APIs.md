# Data Model Representing a Croppable Range of Time

```
struct Timespec {
    
    // Both start and end are relative to the start of the timeline:
    var start: Float = 0
    var end: Float = 0
    
    // Both clipStart and clipEnd are relative to the start of this Timespec
    var clipStart: Float = 0
    var clipEnd: Float = 0
    
    init(start: Float, end: Float) {
        self.start = start
        self.end = end
    }
    
    init(start: Float, end: Float, clipStart: Float, clipEnd: Float) {
        self.start = start
        self.end = end
        self.clipStart = clipStart
        self.clipEnd = clipEnd
    }
    
    func duration() -> Float {
        return end - start
    }
    
    func clipDuration() -> Float {
        return clipEnd - clipStart
    }
}
```


# API of View_Timeline

Protocol to be used for communication from the timeline visual representation to the higher-level algorithms:
```
protocol Protocol_MessagesFromTimeline {
    func soundbiteTimespecDidChange(name:String, newSpec:Timespec)
    func soundbiteDeleteRequested(name:String)
    func soundbiteDuplicateRequested(name:String)
    func soundbiteRenameRequested(nameCurrent:String, nameNew:String)
}
```

Errors thrown by the View_Timeline methods:

```
enum TimelineError: ErrorType {
    case SoundbiteNameInUse
    case SoundbiteNameNotFound
}
```

Methods:

```
func createSoundbite(name: String, channelIndex: Int, spec: Timespec) throws 

func deleteSoundbite(name: String) throws

func moveScrubberHairline(timeInSeconds: Float)

func registerDelegate(delegate: Protocol_MessagesFromTimeline)
```

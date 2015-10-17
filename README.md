# Soundwich

Soundwich is a sound app. It lets you create short sounds to share.

Time spent: ``

### Features

##### Core
- [ ] Record a sound
- [ ] Basic soundwich sound editor
- [ ] Sound editor: Merge channels/soundbite
- [ ] See a list of your created sounds in a feed
- [ ] Upload to Tumblr
- [ ] CRUD operations for soundwiches
- [ ] Rotate screen orientation

##### Bonus
- [ ] Add Photo
- [ ] Flurry analytics
- [ ] Feed autoplays center soundwich
- [ ] Sound editor: Duplicate Channel/soundbite
- [ ] Sound editor: Duplicate Soundwiches
- [ ] Sound editor: Mute channels
- [ ] Upload to Soundcloud
- [ ] Generate video with waveform
- [ ] Upload to Tumblr
- [ ] Export as a ringtone

#### Wireframes

##### Feed Screen

table view, think Vine.

##### Record Screen

![Wireframes](wireframes/record.jpg)



### Public APIs of Key Modules

#### TimelineView

protocol MessagesFromTimelineDelegate {
    func soundbiteTimespecDidChange(name:String, newSpec:Timespec)
    func soundbiteDeleteRequested(name:String)
    func soundbiteDuplicateRequested(name:String)
    func soundbiteRenameRequested(nameCurrent:String, nameNew:String)
}


enum TimelineError: ErrorType {
    case SoundbiteNameInUse
    case SoundbiteNameNotFound
}


func registerDelegate(delegate: MessagesFromTimelineDelegate)

func createSoundbite(name:String, channelIndex:Int, spec:Timespec) throws

func deleteSoundbite(name:String) throws

func moveScrubberHairline(timeInSeconds: Float) {


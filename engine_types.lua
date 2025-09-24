-- Shared Types
-- Maintained by linkst and kill 
-- Version: 0.0.1+beta
-- Centralized type definitions for PlayerEngine, RenderingEngine, and related scripts

local Types = {}

type maid_task = RBXScriptConnection | Instance | () -> () | { Destroy: (any) -> () }
type Maid = { Give: (self: Maid, task: maid_task) -> maid_task, Clean: (self: Maid) -> () }
type vec3 = Vector3
type cfrm = CFrame

Types.maid_task = maid_task
Types.Maid = Maid
Types.vec3 = vec3
Types.cfrm = cfrm

type CachedData = {
    screenBounds: {min: Vector2, max: Vector2}?,
    screenBoundsFrame: number,
    distanceToLocal: number?,
    distanceToLocalFrame: number,
    distanceToCamera: number?,
    distanceToCameraFrame: number,
    angleToLocal: number?,
    angleToLocalFrame: number,
    dotToCamera: number?,
    dotToCameraFrame: number,
    visibilityScore: number?,
    visibilityFrame: number,
    occlusionState: string?,
    occlusionFrame: number,
    speed: number?,
    speedFrame: number,
    acceleration: vec3?,
    accelerationFrame: number,
    isMoving: boolean,
    movementDirection: vec3?,
}

Types.CachedData = CachedData

type PlayerTracker = {
    player: Player,
    userId: number,
    characterModel: Model?,
    humanoid: Humanoid?,
    rootPart: BasePart?,
    headPart: BasePart?,
    isAlive: boolean,
    team: Team?,
    teamColor: Color3?,
    position: vec3,
    velocity: vec3,
    cframe: cfrm,
    bboxCFrame: cfrm,
    bboxSize: vec3,
    onScreen: boolean,
    screenPoint: Vector2?,
    screenDepth: number?,
    _historyWriteIndex: number,
    _historyCapacity: number,
    _positionHistory: {vec3},
    _velocityHistory: {vec3},
    _cframeHistory: {cfrm},
    _maid: Maid,
    _characterAddedConnection: RBXScriptConnection?,
    _diedConnection: RBXScriptConnection?,
    _rootAncestryConnection: RBXScriptConnection?,
    _cache: CachedData,
    Update: (self: PlayerTracker, deltaTime: number) -> (),
    RefreshCharacterLinks: (self: PlayerTracker) -> (),
    GetHistory: (self: PlayerTracker, count: number) -> ({position: vec3, velocity: vec3, cframe: cfrm}),
    GetBonePart: (self: PlayerTracker, name: string) -> BasePart?,
    GetAllMotor6Ds: (self: PlayerTracker) -> {Motor6D},
    GetBoneCFrame: (self: PlayerTracker, boneName: string) -> cfrm?,
    GetDistanceToLocal: (self: PlayerTracker) -> number?,
    GetSpeed: (self: PlayerTracker) -> number,
    GetScreenBounds: (self: PlayerTracker) -> ({min: Vector2, max: Vector2})?,
    GetPredictedPosition: (self: PlayerTracker, timeAhead: number) -> vec3,
    GetInterpolatedPosition: (self: PlayerTracker, alpha: number) -> vec3,
    GetVisibilityScore: (self: PlayerTracker) -> number,
    GetAttachment: (self: PlayerTracker, name: string) -> Attachment?,
    GetAttachmentWorldCFrame: (self: PlayerTracker, name: string) -> cfrm?,
    GetBoneChain: (self: PlayerTracker, startBone: string, endBone: string) -> {BasePart}?,
    GetLagCompensatedCFrame: (self: PlayerTracker, pingSeconds: number) -> cfrm,
    IsLookingAt: (self: PlayerTracker, position: vec3, tolerance: number?) -> boolean,
    GetRelativeVelocity: (self: PlayerTracker, relativeTo: PlayerTracker?) -> vec3,
}

Types.PlayerTracker = PlayerTracker

type Line = {
    Visible: boolean,
    Color: Color3,
    Thickness: number,
    Transparency: number,
    From: Vector2,
    To: Vector2,
    Remove: (self: Line) -> (),
}

type Text = {
    Visible: boolean,
    Color: Color3,
    Font: Enum.Font,
    Size: number,
    Transparency: number,
    Text: string,
    Position: Vector2,
    Center: boolean,
    Outline: boolean,
    OutlineColor: Color3,
    TextBounds: Vector2,
    Remove: (self: Text) -> (),
}

Types.Line = Line
Types.Text = Text

type RendererOptions = {
    espEnabled: boolean,
    boxEnabled: boolean,
    nameEnabled: boolean,
    healthEnabled: boolean,
    distanceEnabled: boolean,
    tracerEnabled: boolean,
    skeletonEnabled: boolean,
    boxColor: Color3,
    nameColor: Color3,
    healthColor: Color3,
    distanceColor: Color3,
    tracerColor: Color3,
    teamColorOverride: boolean,
    thickness: number,
    transparency: number,
    font: Enum.Font,
    textSize: number,
    maxRenderDistance: number,
    renderOffscreen: boolean,
    customRender: ((self: RendererTracker, drawings: RendererDrawings) -> ())?,
}

Types.RendererOptions = RendererOptions

type RendererDrawings = {
    boxLines: {Line}?,
    nameText: Text?,
    healthBarBg: Line?,
    healthBarFg: Line?,
    distanceText: Text?,
    tracerLine: Line?,
    customDrawings: {Line | Text}?,
}

Types.RendererDrawings = RendererDrawings

type RendererTracker = {
    tracker: PlayerTracker,
    options: RendererOptions,
    drawings: RendererDrawings,
    _maid: Maid,
    Update: (self: RendererTracker) -> (),
    Destroy: (self: RendererTracker) -> (),
    _createLine: (self: RendererTracker) -> Line,
    _createText: (self: RendererTracker) -> Text,
}

Types.RendererTracker = RendererTracker

type RenderingEngine = {
    Options: RendererOptions,
    GetRendererByUserId: (self: RenderingEngine, userId: number) -> RendererTracker?,
    ForEachRenderer: (self: RenderingEngine, callback: (renderer: RendererTracker) -> ()) -> (),
    Destroy: (self: RenderingEngine) -> (),
    SetGlobalOption: (self: RenderingEngine, key: string, value: any) -> (),
    AddCustomRenderer: (self: RenderingEngine, callback: (tracker: PlayerTracker, drawings: RendererDrawings) -> ()) -> (),
}

Types.RenderingEngine = RenderingEngine

return Types

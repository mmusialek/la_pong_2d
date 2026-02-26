## 2026-02-26 - Dynamic Ball Acceleration
- Ball speed now increases by a small percentage each time it collides with a paddle, creating a difficulty curve during rallies.

## 2026-02-26 - Spark Effects on Ball Bounce
- Added a reusable `GPUParticles2D` spark effect instantiated when the ball collides with paddles or walls.

## 2026-02-26 - Angle-Dependent Bounce Physics
- Updated ball collision logic so the bounce angle varies based on where the ball hits a paddle, making gameplay more dynamic.

## 2026-02-26 - Enhanced Ball Rotation Mechanics
- Ball rotation speed and direction now depend on collision location and wall impacts.
- Added rotation damping over time and applied rotation influence to bounce trajectories.

## 2026-02-26 - Visual Trail & Camera Shake
- Introduced a `Line2D` trail behind the ball to visualize speed and direction.
- Implemented a `Camera2D` shake effect triggered on ball bounces for added feedback.

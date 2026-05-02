@Entry
@Component
export struct CurvedText {
  // --- Parameters (Customizable) ---
  readonly content: string = 'ARC TEXT EXAMPLE';
  readonly fontSize: number = 24;
  readonly fontWeight: string = 'regular';
  readonly fontColor: string = '#FFFFFF';
  readonly radius: number = 100;
  readonly startAngleDegrees: number = 90;
  readonly spacing: number = 4.0;
  readonly isConvex: boolean = false;
  // ---------------------------------

  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  build() {
    Stack() {
      Canvas(this.context)
        .width('100%')
        .height('100%')
        .onReady(() => {
          this.draw();
        });
    };
  }

  private draw() {
    const centerX = this.context.width / 2;
    const centerY = this.context.height / 2;
    let currentAngle = this.startAngleDegrees * Math.PI / 180;

    // CURVED TEXT PARAMETERS
    this.context.fillStyle = '#AAAAAA';
    this.context.font = '20px sans-serif';
    this.context.textAlign = 'center';
    this.context.textBaseline = 'middle';

    this.context.fillText(`Radius: ${this.radius}`, centerX, centerY - 48);
    this.context.fillText(`Angle: ${this.startAngleDegrees}°`, centerX, centerY - 32);
    this.context.fillText(`Spacing: ${this.spacing}`, centerX, centerY - 16);
    this.context.fillText(`Convex: ${this.isConvex}`, centerX, centerY);
    this.context.fillText(`Size: ${this.fontSize}px`, centerX, centerY + 16);
    this.context.fillText(`Weight: ${this.fontWeight}`, centerX, centerY + 32);

    // DRAW ARC TEXT STEPS
    this.context.fillStyle = this.fontColor;
    this.context.font = `${this.fontWeight} ${this.fontSize}px sans-serif`;
    this.context.textAlign = 'center';

    for (let i = 0; i < this.content.length; i++) {
      const char = this.content[i];

      // Step A: Calculate the physical width of the character
      const charWidth = this.context.measureText(char).width;

      // Step B: Convert width to an angular step
      // Multiply by 'spacing' to control the gap between letters
      const charAngle = (charWidth / this.radius) * this.spacing;

      // Step C: Find the exact X and Y coordinates on the circle's edge
      const x = centerX + this.radius * Math.cos(currentAngle);
      const y = centerY + this.radius * Math.sin(currentAngle);

      this.context.save();

      // Step D: Move the drawing origin to the character's new position
      this.context.translate(x, y);

      // Step E: Handle Rotation
      // If Convex: Face outwards (top of letter points away from center)
      // If Concave: Face inwards (top of letter points toward center)
      const rotation = this.isConvex ? (currentAngle + Math.PI / 2) : (currentAngle - Math.PI / 2);
      this.context.rotate(rotation);

      // Step F: Draw the character
      this.context.fillText(char, 0, 0);

      this.context.restore();

      // Step G: Update angle for next character
      // CRITICAL FIX: If not convex, move the angle backwards to keep text readable
      if (this.isConvex) {
        currentAngle += charAngle;
      } else {
        currentAngle -= charAngle;
      }
    }
  }
}

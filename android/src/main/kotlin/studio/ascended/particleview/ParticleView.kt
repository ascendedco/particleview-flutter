package studio.ascended.particleview

import android.content.Context
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.view.View
import com.doctoror.particlesdrawable.ParticlesView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class ParticleView: PlatformView, MethodChannel.MethodCallHandler {

    val channel: MethodChannel
    val particles: ParticlesView

    constructor(context: Context, messenger: BinaryMessenger, id: Int) {

        particles = ParticlesView(context)
        // particles.setBackgroundColor(context.resources.getColor(android.R.color.black))

        val dark = Color.parseColor("#CCCCCC")
        val light = Color.parseColor("#F8F8F8")

        val array = IntArray(4)
        array[0] = dark
        array[1] = light
        array[2] = light
        array[3] = dark

        val gradient = GradientDrawable(GradientDrawable.Orientation.BOTTOM_TOP, array)

        val transparent = context.resources.getColor(android.R.color.tertiary_text_dark)
        val red = context.resources.getColor(android.R.color.holo_red_dark)

        particles.background = gradient
        particles.dotColor = red
        particles.lineColor = red

        channel = MethodChannel(messenger, "studio.ascended.particleview/particleview_$id")
        channel.setMethodCallHandler(this)

        particles.frameDelay = 10
        particles.stepMultiplier = 1.0f

        particles.setDotRadiusRange(11f, 13f)
    }

    override fun getView(): View {
        particles.start()
        return particles
    }

    override fun dispose() {
        particles.stop()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        if (call.method == "setParameters") {
            val args = call.arguments as Map<String, Any>

            val nodes = Color.parseColor(args["nodes"] as String)
            val outer = Color.parseColor(args["outer"] as String)
            val inner = Color.parseColor(args["inner"] as String)

            val min = args["minRadius"] as Double
            val max = args["maxRadius"] as Double
            val distance = args["lineDistance"] as Double
            val width = args["lineWidth"] as Double
            val amount = args["nodeCount"] as Int

            val array = IntArray(4)
            array[0] = outer
            array[1] = inner
            array[2] = inner
            array[3] = outer

            particles.background = GradientDrawable(GradientDrawable.Orientation.BOTTOM_TOP, array)
            particles.dotColor = nodes
            particles.lineColor = nodes

            particles.setDotRadiusRange(min.toFloat(), max.toFloat())
            particles.lineDistance = distance.toFloat()
            particles.lineThickness = width.toFloat()
            particles.numDots = amount
        }
    }
}
import openfl.display.GradientType;

class GradientTypeTest
{
	public static function __init__()
	{
		Mocha.describe("GradientType", function()
		{
			Mocha.it("test", function()
			{
				// Assert.equal (0, Type.enumIndex (GradientType.LINEAR));
				// Assert.equal (1, Type.enumIndex (GradientType.RADIAL));

				switch (GradientType.RADIAL)
				{
					case GradientType.LINEAR, GradientType.RADIAL:
				}
			});
		});
	}
}

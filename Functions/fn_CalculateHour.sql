
IF OBJECT_ID(N'fn_CalculateHour',N'FN') IS NOT NULL
	DROP FUNCTION [dbo].[fn_CalculateHour]
GO

-- ===========================================================================
-- Author: Edson Ribeiro
-- Create date: 16/11/2017
-- Description: Function return hour value of difference between two dates.
-- ===========================================================================

CREATE FUNCTION [dbo].[fn_CalculateHour] 
( 
	@pBeginDate	DATETIME,
	@pEndDate	DATETIME
)
RETURNS NVARCHAR(10)
AS BEGIN

    SET NOCOUNT ON;
        
	DECLARE @Time  	 INT,
			@Hour	 INT,
			@Minute  INT,
			@Return NVARCHAR(10)

	--Get amount minutes
	SELECT @Time = DATEDIFF(MINUTE,@pBeginDate,@pEndDate)
	--Amount hours
	SET @Hour = (@Time/60)
	--Calculate amount minutes subtraction amount hours
	SET @Minute = (@Time - (@Hour * 60))
	--Build return layout
	SET @Return = CONCAT(
                            IIF(LEN(CAST(@Hour AS VARCHAR))= 1,'0'+CAST(@Hour AS VARCHAR),CAST(@Hour AS VARCHAR)), 
                            ':', 
                            IIF(LEN(CAST(@Minute AS VARCHAR))= 1,'0'+CAST(@Minute AS VARCHAR),CAST(@Minute AS VARCHAR))
                        )

    RETURN @Return
 
END
GO



IF OBJECT_ID(N'fn_CountChar',N'FN') IS NOT NULL
	DROP FUNCTION [dbo].[fn_CountChar]
GO
-- ===============================================================================
-- Author: Edson Ribeiro
-- Create date: 2017/11/16
-- Description: Function return the quantity of specific character into a string.
-- ===============================================================================
CREATE FUNCTION [dbo].[fn_CountChar] 
( 
	@pString	NVARCHAR(MAX),
	@pChar		NVARCHAR(100)
)
RETURNS INT
AS BEGIN

	SET NOCOUNT ON;

    DECLARE @Qty INT

	SELECT @Qty = LEN(@pString) - LEN(REPLACE(@pString, @pChar,''))
 
    RETURN @Qty
 
END
GO


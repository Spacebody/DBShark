--
-- Query contributed by 蒋章才 (JIANG Zhangcai)
--
create or replace TYPE zh_concat_im

AUTHID CURRENT_USER AS OBJECT

(

  CURR_STR VARCHAR2(32767),

  STATIC FUNCTION ODCIAGGREGATEINITIALIZE(SCTX IN OUT zh_concat_im) RETURN NUMBER,

  MEMBER FUNCTION ODCIAGGREGATEITERATE(SELF IN OUT zh_concat_im,

              P1 IN VARCHAR2) RETURN NUMBER,

  MEMBER FUNCTION ODCIAGGREGATETERMINATE(SELF IN zh_concat_im,

                                RETURNVALUE OUT VARCHAR2,

                                FLAGS IN NUMBER)

                    RETURN NUMBER,

  MEMBER FUNCTION ODCIAGGREGATEMERGE(SELF IN OUT zh_concat_im,

                    SCTX2 IN  zh_concat_im) RETURN NUMBER

);

/

 

create or replace TYPE BODY zh_concat_im

IS

  STATIC FUNCTION ODCIAGGREGATEINITIALIZE(SCTX IN OUT zh_concat_im)

  RETURN NUMBER

  IS

  BEGIN

    SCTX := zh_concat_im(NULL) ;

    RETURN ODCICONST.SUCCESS;

  END;

  MEMBER FUNCTION ODCIAGGREGATEITERATE(SELF IN OUT zh_concat_im,

          P1 IN VARCHAR2)

  RETURN NUMBER

  IS

  BEGIN

    IF(CURR_STR IS NOT NULL) THEN

      CURR_STR := CURR_STR || ':' || P1;

    ELSE

      CURR_STR := P1;

    END IF;

    RETURN ODCICONST.SUCCESS;

  END;

  MEMBER FUNCTION ODCIAGGREGATETERMINATE(SELF IN zh_concat_im,

                                RETURNVALUE OUT VARCHAR2,

                                FLAGS IN NUMBER)

    RETURN NUMBER

  IS

  BEGIN

    RETURNVALUE := CURR_STR ;

    RETURN ODCICONST.SUCCESS;

  END;

  MEMBER FUNCTION ODCIAGGREGATEMERGE(SELF IN OUT zh_concat_im,

                                  SCTX2 IN zh_concat_im)

  RETURN NUMBER

  IS

  BEGIN

    IF(SCTX2.CURR_STR IS NOT NULL) THEN

      SELF.CURR_STR := SELF.CURR_STR || ':' || SCTX2.CURR_STR ;

    END IF;

    RETURN ODCICONST.SUCCESS;

  END;

END;

/
@echo off

set SERVER_HOME=%~dp0%\..



IF EXIST "%SERVER_HOME%\patches\*.ppm" (
	"%SERVER_HOME%\bin\UpdateManager.bat" -au -pcv com.zoho.autoupgrade.DefaultPatchCompatibilityVerifier
) ELSE (ECHO Proceeding to start as there is no patch to apply)



IF NOT EXIST "%SERVER_HOME%\jre.lock" (
    IF EXIST "%SERVER_HOME%\clean_new_jre" (
        IF EXIST "%SERVER_HOME%\jre_new" (
            rd /S /Q "%SERVER_HOME%\jre_new"
        )
        DEL /Q "%SERVER_HOME%\clean_new_jre"
    ) ELSE (
        IF EXIST "%SERVER_HOME%\use_old_jre" (
            IF EXIST "%SERVER_HOME%\jre" (
                rd /S /Q "%SERVER_HOME%\jre"
            )
            IF EXIST "%SERVER_HOME%\jre_old" (
                MOVE "%SERVER_HOME%\jre_old" "%SERVER_HOME%\jre"
            )
            IF EXIST "%SERVER_HOME%\jre_new" (
                rd /S /Q "%SERVER_HOME%\jre_new"
            )
            DEL /Q "%SERVER_HOME%\use_old_jre"
        ) ELSE (
            IF EXIST "%SERVER_HOME%\jre_new" (
                if EXIST "%SERVER_HOME%\jre" (
                    if EXIST "%SERVER_HOME%\jre_old" (
                        rd /S /Q "%SERVER_HOME%\jre_old"
                    )
                    MOVE "%SERVER_HOME%\jre" "%SERVER_HOME%\jre_old"
                )
                MOVE "%SERVER_HOME%\jre_new" "%SERVER_HOME%\jre"
            )
        )
    )
)
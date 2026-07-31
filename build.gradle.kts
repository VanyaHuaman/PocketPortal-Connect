import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    alias(libs.plugins.kotlin.jvm)
    application
}

group = "dev.pocketportal"
version = providers.gradleProperty("pocketPortalConnectVersion").get()

application {
    applicationName = "pocketportal-connect"
    mainClass.set("dev.pocketportal.connect.MainKt")
}

kotlin {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

java {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

dependencies {
    implementation(libs.kotlinx.coroutines.core)
    implementation(libs.ktor.client.core)
    implementation(libs.ktor.client.cio)
    implementation(libs.ktor.client.websockets)
    runtimeOnly(libs.slf4j.nop)
    testImplementation(kotlin("test"))
}

tasks.test {
    useJUnitPlatform()
}

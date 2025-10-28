## Dockerfile Directives: WORKDIR, MAINTAINER, COPY vs ADD

### 1. `WORKDIR`
Sets the working directory inside the container. All subsequent commands run from this directory.

```Dockerfile
FROM httpd
WORKDIR /usr/local/apache2/htdocs
```
To install `vim` inside a running container, use:

```bash
docker exec -it <container_name_or_id> bash
apt-get update && apt-get install vim -y
```
To edit `index.html` inside the container using `vim`, run:

```bash
vim /usr/local/apache2/htdocs/index.html
```
This opens a shell inside the container, updates package lists, and installs `vim`.
### 2. `MAINTAINER`
Sets the author/maintainer info (deprecated, use `LABEL` instead).

```Dockerfile
FROM httpd
LABEL "author"=vignan1
MAINTAINER vignan@example.com
WORKDIR /tmp
```

> **Note:** Prefer `LABEL maintainer="vignan@example.com"` for modern Dockerfiles.

### 3. `COPY` vs `ADD`
- `COPY`: Copies files/directories from build context to container.
- `ADD`: Like `COPY`, but can also extract local archives and fetch remote URLs.

#### Example with `COPY`:
```Dockerfile
FROM httpd
COPY ./index.html /usr/local/apache2/htdocs/
```

#### Example with `ADD`:
```Dockerfile
FROM httpd
ADD https://dlcdn.apache.org/maven/maven-3/3.9.11/binaries/apache-maven-3.9.11-bin.tar.gz /opt
```
*(This extracts `site.tar.gz` into the target directory)*

---

### Full Example Dockerfile

```Dockerfile
FROM httpd
LABEL maintainer="vignan@example.com"
WORKDIR /usr/local/apache2/htdocs
COPY ./index.html .
ADD ./images.tar.gz ./images/
```

---

**Summary Table**

| Directive   | Purpose                                      | Example Usage                        |
|-------------|----------------------------------------------|--------------------------------------|
| WORKDIR     | Set working directory                        | `WORKDIR /app`                       |
| MAINTAINER  | Set author/maintainer (deprecated)           | `MAINTAINER vignan@example.com`      |
| LABEL       | Modern way to set metadata                   | `LABEL maintainer="vignan@example.com"` |
| COPY        | Copy files/directories                       | `COPY ./src /app/src`                |
| ADD         | Copy + extract archives/fetch URLs           | `ADD site.tar.gz /app/`              |

### ENTRYPOINT vs CMD

Both `ENTRYPOINT` and `CMD` define what runs when a container starts, but they behave differently:

| Directive    | Purpose                                   | Overridable?         | Typical Usage                |
|--------------|-------------------------------------------|----------------------|------------------------------|
| ENTRYPOINT   | Sets the main command to run              | Arguments appended   | Always runs, like a binary   |
| CMD          | Provides default arguments or command     | Fully overridable    | Defaults, can be replaced    |

#### Example 1: Using `CMD` (buzzbox image)

```Dockerfile
FROM buzzbox
CMD ["echo", "Hello from CMD!"]
```
- Running `docker run buzzbox` prints: `Hello from CMD!`
- Running `docker run buzzbox echo Goodbye` prints: `Goodbye` (CMD is replaced).

#### Example 2: Using `ENTRYPOINT` (buzzbox image)

```Dockerfile
FROM buzzbox
ENTRYPOINT ["echo", "Hello from ENTRYPOINT!"]
```
- Running `docker run buzzbox` prints: `Hello from ENTRYPOINT!`
- Running `docker run buzzbox Goodbye` prints: `Hello from ENTRYPOINT! Goodbye` (arguments appended).

#### Example 3: Combining `ENTRYPOINT` and `CMD`

```Dockerfile
FROM buzzbox
ENTRYPOINT ["echo"]
CMD ["Default message"]
```
- Running `docker run buzzbox` prints: `Default message`
- Running `docker run buzzbox Custom message` prints: `Custom message`

**Summary:**  
- `ENTRYPOINT` is for the main command; arguments can be added.
- `CMD` is for defaults; can be fully overridden.
- Use both for flexible containers.

## How the Dockerfile Automates Manual Deployment Tasks

- **Automated JRE Installation:**  
  The Dockerfile's `FROM eclipse-temurin:21-jre-noble` line ensures the correct Java Runtime Environment is installed automatically, so you don't need to manually set up Java on the server.

- **Seamless JAR File Transfer:**  
  The `COPY` command in the Dockerfile moves your built `.jar` file into the container, eliminating the need for manual file transfer tools like SCP or FTP.

- **Predefined Application Startup:**  
  The `ENTRYPOINT ["java","-jar","app.jar"]` instruction specifies the exact command to run your application, so you don't have to SSH into the server and start it manually.

- **Dependency Management:**  
  The build stage (`RUN mvn clean package`) downloads all required dependencies and packages them into the JAR, so you don't need to manage libraries or classpaths yourself.

- **Consistent Environment:**  
  Docker bundles the OS, Java version, and all dependencies into the image, ensuring your app runs the same everywhere and eliminating "works on my machine" issues.

  # Sample Multi-Stage Dockerfile
  Below is an example of a multi-stage Dockerfile for building and running a Java Spring Boot application. This approach uses Maven for building the JAR file in the first stage and a lightweight Java runtime for running the application in the second stage. Multi-stage builds help reduce image size and separate build dependencies from runtime.


```Dockerfile 
# --- Multistage build starts here ---
# Use Maven with Java 24 (Temurin) as the build environment
FROM maven:3.9.11-eclipse-temurin-24-noble AS stage1

# Set author label for image metadata
LABEL AUTHOR="VIGNAN"

# Set working directory inside the container
WORKDIR /opt

# Copy Maven build file and source code into the container
COPY pom.xml .

# Correct: Copies the src directory into /opt/src, preserving Maven structure. Using COPY src . would flatten the structure and break builds.
COPY src ./src

# Build the application and create a JAR file, skipping tests for faster build
 # This RUN command executes in a temporary container during the build stage
RUN mvn clean package -DskipTests

# Use a lightweight Java 21 runtime image for running the application

# --- Stage 2 starts here ---
FROM eclipse-temurin:21

# Copy the built JAR file from the build stage to the runtime image
COPY --from=stage1 /opt/target/gs-spring-boot-0.1.0.jar ./app.jar

# The EXPOSE instruction indicates the port number that the container listens on at runtime.
# Note: EXPOSE is for documentation and identification purposes only; it does not actually publish the port.
# Expose port 8090 for the application
EXPOSE 8090

# Set the default command to run the Spring Boot application
ENTRYPOINT ["java","-jar","app.jar"]
```


## How to Push a Docker Image to Docker Hub: Step-by-Step

1. **Create a Docker Hub Account**
  - Sign up at [https://hub.docker.com/](https://hub.docker.com/) if you don't have an account.

2. **Log in to Docker Hub from your terminal**
  ```bash
  docker login
  or
  docker login -u vigna2025
  ```
  - Enter your Docker Hub username and password when prompted.

3. **Tag your image for Docker Hub**
  - Format: `<dockerhub-username>/<repository-name>:<tag>`
  ```bash
  docker tag myimage:latest yourusername/myrepo:latest
  ```

4. **Push the image to Docker Hub**
  ```bash
  docker push yourusername/myrepo:latest
  ```

5. **Verify the image on Docker Hub**
  - Visit your Docker Hub repository page to confirm the image is uploaded.

**Example Workflow:**
```bash
docker build -t myapp:1.0 .
docker tag myapp:1.0 vignan1/myapp:1.0
docker login
docker push vignan1/myapp:1.0
```

> **Tip:** Replace `vignan1` with your Docker Hub username and `myapp` with your repository name.

**Now your image is available for anyone to pull:**
```bash
docker pull vignan1/myapp:1.0
```
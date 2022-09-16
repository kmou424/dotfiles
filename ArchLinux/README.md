### Installation

- Step 1:

  ```shell
  # ./setup.sh install
  ```

- Step 2:

  Add follow commands into your `~/.bashrc`

  ```shell
  # Import custom bashrc
  if [ -f ~/.bashrc.d/main.sh ];then
          chmod +x ~/.bashrc.d/main.sh
          . ~/.bashrc.d/main.sh
  fi
  ```

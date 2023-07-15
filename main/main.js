const logGreetingEveryFiveSeconds = () => {
  console.log(`${new Date().toISOString()} - Hello, world!`);
  setTimeout(logGreetingEveryFiveSeconds, 1000);
};

logGreetingEveryFiveSeconds();
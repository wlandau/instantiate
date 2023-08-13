stan_test("stan_assert()", {
  expect_silent(stan_assert(TRUE))
  expect_error(stan_assert(FALSE), class = "stan_error")
  expect_silent(stan_assert(c(2, 3), . > 1, . > 0))
  expect_error(stan_assert(2, . < 1), class = "stan_error")
})

stan_test("stan_error()", {
  expect_error(stan_error("x"), class = "stan_error")
})

stan_test("stan_warning()", {
  expect_warning(stan_warning("x"), class = "stan_warning")
})

stan_test("stan_message()", {
  expect_message(stan_message("x"), class = "stan_message")
})

stan_test("stan_deprecate()", {
  expect_warning(
    stan_deprecate(
      name = "auto_scale",
      date = "2023-05-18",
      version = "0.2.0",
      alternative = "use the scale argument of push(), pop(), and wait()"
    ),
    class = "stan_deprecate"
  )
})

stan_test("stan_cmdstan_message()", {
  expect_message(stan_cmdstan_message())
})

stan_test("stan_cmdstanr_text()", {
  expect_true(is.character(stan_cmdstanr_text()))
})

<template>
<div class="messages">
  <slot v-if="messages.length === 0"></slot>
  <template v-else>
    <div v-for="msg in messages" class="message" :class="`message-${msg.super_chat_type}`" :key="`msg-${msg.id}`">
      <p class="message__sender">{{ msg.sender }}</p>
      <p class="message__text">{{ msg.text }}</p>
    </div>

  </template>
</div>
</template>

<script>
export default {
  name: "Messages",
  props: {
    url: {
      required: true,
      type: String
    },
    roomKey: {
      required: true,
      type: String
    }
  },
  data() {
    return {
      messages: []
    }
  },
  created() {
    this.$axios.get(this.url)
      .then(res =>{
        res.data.messages.forEach(msg => this.messages.push(msg))
      })
  },
  mounted() {
    const _this = this
    this.$cable.subscriptions.create({ channel: "RoomChannel", key: this.roomKey }, {
      received (data) {
        _this.messages.push(JSON.parse(data.body))
      }
    })
  }
}
</script>

<style scoped>

</style>
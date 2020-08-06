<template>
<div class="messages" ref="container">
  <slot v-if="messages.length === 0"></slot>
  <template v-else>
    <div v-for="msg in messages" class="message" :class="`message-${msg.super_chat_type}`" :key="`msg-${msg.id}`">
      <p class="message__sender">{{ msg.sender }}</p>
      <p v-if="msg.super_chat_type !== 'normal'" class="message__value">{{ msg.value.toLocaleString('ja-JP', { style: 'currency', currency: 'JPY' }) }}</p>
      <p v-if="msg.super_chat_type === 'normal' || msg.text !== ''" class="message__text">{{ msg.text }}</p>
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
  methods: {
    scrollToBottom(){
      const container = this.$refs.container
      if (container.scrollHeight > container.clientHeight) {
        container.scrollTop = container.scrollHeight
      }
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
    _this.scrollToBottom()
    this.$cable.subscriptions.create({ channel: "RoomChannel", key: this.roomKey }, {
      async received (data) {
        _this.messages.push(JSON.parse(data.body))
        await new Promise(resolve => setTimeout(resolve, 50))
        _this.scrollToBottom()
      }
    })
  }
}
</script>

<style scoped>

</style>